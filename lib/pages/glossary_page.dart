import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

//defines StatefulWidget for Glossary page
class GlossaryPage extends StatefulWidget {
  const GlossaryPage({Key? key}) : super(key: key); //constructor with optional key

  @override
  //creates mutable state for this StatefulWidget
  _GlossaryPageState createState() => _GlossaryPageState();
}

//state class for GlossaryPage (handles dynamic aspects of page)
class _GlossaryPageState extends State<GlossaryPage> {
  //reference to 'Ingredients' node in database
  final DatabaseReference _ingredientsRef = FirebaseDatabase.instance.ref('Ingredients');
  
  //list to hold ingredients
  List<Map<String, String>> _displayedIngredients = [];
  
  //tracks index of currently expanded ingredient list
  int? _expandedIndex;
  
  //number of ingredients to load per batch
  final int _batchSize = 10;
  
  //boolean flag to check if there are more items to be loaded
  bool _hasMore = true;

  @override
  //initial state setup, loads first batch of ingredients
  void initState() {
    super.initState();
    _loadIngredients();
  }

  //async load ingredients from Firebase, handling pagination
  void _loadIngredients() async {
    DatabaseEvent event = await _ingredientsRef
        .orderByKey()
        .limitToFirst(_displayedIngredients.length + _batchSize)
        .once();

    List<Map<String, String>> loadedIngredients = [];

    final snapshotData = event.snapshot.value;

    if (snapshotData != null) {
      if (snapshotData is Map<dynamic, dynamic>) {
        // ✅ Your ideal case — map with custom keys
        snapshotData.forEach((key, value) {
          loadedIngredients.add({
            "name": value["Name"] ?? "Unnamed",
            "description": value["Description"] ?? "No Description",
            "healthImpact": value["Health Rating"].toString(),
            "category": value["Category"] ?? "Unknown",
          });
        });
      } else if (snapshotData is List) {
        // 🔁 Backup: handles list-based structure
        for (var value in snapshotData) {
          if (value != null) {
            loadedIngredients.add({
              "name": value["Name"] ?? "Unnamed",
              "description": value["Description"] ?? "No Description",
              "healthImpact": value["Health Rating"].toString(),
              "category": value["Category"] ?? "Unknown",
            });
          }
        }
      }

      if (loadedIngredients.length <= _displayedIngredients.length) {
        _hasMore = false;
      }
    } else {
      _hasMore = false;
  }

  setState(() {
    _displayedIngredients = loadedIngredients;
  });
}

  @override
  //builds widget tree for the Glossary page
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossary'), //title for the AppBar
        backgroundColor: Colors.green, //appBar background color
      ),
      body: ListView.builder(
        itemCount: _displayedIngredients.length + (_hasMore ? 1 : 0), //increase count if more items can be loaded
        itemBuilder: (context, index) {
          //load more button is shown if there are more items to load
          if (index == _displayedIngredients.length && _hasMore) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton(
                onPressed: _loadIngredients,
                child: const Text('Load More'),
              ),
            );
          }
          //constructs a ListTile for each ingredient
          final ingredient = _displayedIngredients[index];
          bool isExpanded = _expandedIndex == index; //checks if tile is expanded

          return ListTile(
            title: Text(ingredient['name']!),
            subtitle: isExpanded ? Text("${ingredient['description']} \nHealth Rating (10 being the best): ${ingredient['healthImpact']} \nCategory: ${ingredient['category']}") : null,
            onTap: () {
              setState(() {
                //toggle expanded state
                if (isExpanded) {
                  _expandedIndex = null; //collapse the current item
                } else {
                  _expandedIndex = index; //expand the tapped item
                }
              });
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
