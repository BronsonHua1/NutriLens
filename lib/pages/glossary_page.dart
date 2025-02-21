import 'package:flutter/material.dart';
import 'dart:math';

class GlossaryPage extends StatefulWidget {
  const GlossaryPage({super.key});

  @override
  _GlossaryPageState createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  final List<Map<String, String>> _allIngredients = List.generate(
    50, // Simulating 50 ingredients
    (index) => {
      "name": "Ingredient ${index + 1}",
      "description": "This is the description of Ingredient ${index + 1}.",
    },
  );

  List<Map<String, String>> _displayedIngredients = [];
  int _loadedCount = 10; // Start with 10 ingredients
  final Set<int> _expandedIndices = {}; // Tracks expanded items
  final Map<int, Color> _ingredientColors = {}; // Stores assigned colors

  final List<Color> _colors = [
    Colors.green.withOpacity(0.3), // Green
    Colors.red.withOpacity(0.3),   // Red
    Colors.yellow.withOpacity(0.3),// Yellow
    Colors.grey.withOpacity(0.3),  // Grey
  ];

  @override
  void initState() {
    super.initState();
    _assignColors();
    _loadMoreIngredients(); // Load initial 10 items
  }

  /// Assigns a random color to each ingredient
  void _assignColors() {
    final random = Random();
    for (int i = 0; i < _allIngredients.length; i++) {
      _ingredientColors[i] = _colors[random.nextInt(_colors.length)];
    }
  }

  void _loadMoreIngredients() {
    setState(() {
      int nextCount = _loadedCount + 10;
      _displayedIngredients = _allIngredients.sublist(0, nextCount.clamp(0, _allIngredients.length));
      _loadedCount = nextCount;
    });
  }

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Glossary"), backgroundColor: Colors.green),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _displayedIngredients.length + 1, // Extra 1 for Load More Button
              itemBuilder: (context, index) {
                if (index < _displayedIngredients.length) {
                  final ingredient = _displayedIngredients[index];
                  final isExpanded = _expandedIndices.contains(index);
                  final backgroundColor = _ingredientColors[index] ?? Colors.transparent;

                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor, // Highlighting the ingredient
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          title: Text(
                            ingredient["name"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: isExpanded ? Text(ingredient["description"]!) : null,
                          trailing: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.green,
                          ),
                          onTap: () => _toggleExpand(index),
                        ),
                      ),
                      if (isExpanded) const Divider(thickness: 1),
                    ],
                  );
                } else if (_loadedCount < _allIngredients.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _loadMoreIngredients,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("Load More", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink(); // Hide the button if all are loaded
              },
            ),
          ),
        ],
      ),
    );
  }
}
