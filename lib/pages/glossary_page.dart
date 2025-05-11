import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/local_ingredient_database_service.dart'; // << your local DB import

class GlossaryPage extends StatefulWidget {
  const GlossaryPage({Key? key}) : super(key: key);

  @override
  _GlossaryPageState createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  final DatabaseReference _ingredientsRef = FirebaseDatabase.instance.ref('Ingredients');

  List<Map<String, dynamic>> _displayedIngredients = [];
  int? _expandedIndex;
  final int _batchSize = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  // Loads both Firebase and local ingredients
  Future<void> _loadIngredients() async {
    DatabaseEvent event = await _ingredientsRef
        .orderByKey()
        .limitToFirst(_displayedIngredients.length + _batchSize)
        .once();

    List<Map<String, dynamic>> loadedFirebaseIngredients = [];

    final snapshotData = event.snapshot.value;

    if (snapshotData != null) {
      if (snapshotData is Map<dynamic, dynamic>) {
        snapshotData.forEach((key, value) {
          loadedFirebaseIngredients.add({
            "name": value["Name"] ?? "Unnamed",
            "description": value["Description"] ?? "No Description",
            "healthImpact": value["Health Rating"].toString(),
            "category": value["Category"] ?? "Unknown",
            "source": "firebase", // Tagging
          });
        });
      } else if (snapshotData is List) {
        for (var value in snapshotData) {
          if (value != null) {
            loadedFirebaseIngredients.add({
              "name": value["Name"] ?? "Unnamed",
              "description": value["Description"] ?? "No Description",
              "healthImpact": value["Health Rating"].toString(),
              "category": value["Category"] ?? "Unknown",
              "source": "firebase",
            });
          }
        }
      }

      if (loadedFirebaseIngredients.length <= _displayedIngredients.length) {
        _hasMore = false;
      }
    } else {
      _hasMore = false;
    }

    // 🔥 Load local ingredients too
    List<Map<String, dynamic>> localIngredients = await _loadLocalIngredients();

    // Combine local + Firebase
    setState(() {
      _displayedIngredients = [...localIngredients, ...loadedFirebaseIngredients];
    });
  }

  // Loads local SQLite ingredients
  Future<List<Map<String, dynamic>>> _loadLocalIngredients() async {
    final localIngredients = await IngredientDatabase.instance.getIngredients();
    return localIngredients.map((ingredient) => {
      "name": ingredient['name'] ?? "Unnamed",
      "description": ingredient['description'] ?? "No Description",
      "healthImpact": ingredient['healthRating']?.toString() ?? "Unknown",
      "category": ingredient['category'] ?? "Unknown",
      "source": "local",
    }).toList();
  }

  // Deletes a local ingredient
  Future<void> _deleteLocalIngredient(Map<String, dynamic> ingredient) async {
    if (ingredient['source'] == 'local') {
      final name = ingredient['name'];
      final localIngredients = await IngredientDatabase.instance.getIngredients();
      final match = localIngredients.firstWhere((item) => item['name'] == name, orElse: () => {});
      if (match.isNotEmpty) {
        final id = match['id'];
        if (id != null) {
          await IngredientDatabase.instance.deleteIngredient(id);
          _loadIngredients();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossary'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: _displayedIngredients.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _displayedIngredients.length && _hasMore) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton(
                onPressed: _loadIngredients,
                child: const Text('Load More'),
              ),
            );
          }

          final ingredient = _displayedIngredients[index];
          bool isExpanded = _expandedIndex == index;

          return ListTile(
            title: Row(
              children: [
                Text(ingredient['name'] ?? ''),
                if (ingredient['source'] == 'local')
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.phone_android, size: 18, color: Colors.blue),
                  ),
              ],
            ),
            subtitle: isExpanded
                ? Text(
                    "${ingredient['description']} \n\n"
                    "Health Rating (10 is best): ${ingredient['healthImpact']} \n"
                    "Category: ${ingredient['category']} \n"
                    "Source: ${ingredient['source'] == 'local' ? 'Local Device' : 'Online Database'}",
                  )
                : null,
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedIndex = null;
                } else {
                  _expandedIndex = index;
                }
              });
            },
            onLongPress: () async {
              if (ingredient['source'] == 'local') {
                bool? confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Ingredient'),
                    content: Text('Are you sure you want to delete "${ingredient['name']}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirmDelete == true) {
                  await _deleteLocalIngredient(ingredient);
                }
              }
            },
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
          );
        },
      ),
    );
  }
}
