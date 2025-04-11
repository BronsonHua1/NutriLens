import 'package:flutter/material.dart';
import '../services/health_rating_service.dart';
import '../data/product_ingredient_data.dart';
import '../services/open_food_api_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int? _healthScore;
  List<String> _matchedIngredients = [];
  List<String> _suggestions = [
    "coca cola",
    "fruit punch juice drink",
    "orange juice",
    "green tea",
    "peanut butter",
    "energy drink",
    "soda",
    "water",
    "protein bar",
    "chocolate milk",
    "almond milk",
    "yogurt",
    "granola bar",
    "cola zero",
    "monster energy",
    "apple juice",
    "lemonade",
    "snack chips",
    "diet soda",
    "sports drink",
    "sparkling water",
    "vegetable juice",
    "milk chocolate",
    "dark chocolate",
    "trail mix",
    "instant noodles"
  ];
  List<String> _filteredSuggestions = [];

  // Analyzes the input to retrieve ingredients and calculate health score
  Future<void> _analyzeSearch() async {
    final input = _searchController.text.toLowerCase().trim();
    if (input.isEmpty) return;

    final apiService = OpenFoodApiService();
    List<String> ingredients = await apiService.fetchIngredients(input);

    if (ingredients.isEmpty) {
      ingredients = input.split(",").map((e) => e.trim()).toList();
    }

    final result = HealthRatingService.analyzeIngredients(ingredients);

    setState(() {
      _healthScore = result["score"];
      _matchedIngredients = ingredients;
    });

    if (result["harmful_count"] > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚠️ ${result["harmful_count"]} harmful ingredient(s) detected!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Builds the colored badge that shows the health score
  Widget buildHealthScoreBadge(int score) {
    Color badgeColor;
    if (score >= 8) {
      badgeColor = Colors.green;
    } else if (score >= 5) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.red;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Health Score: $score/10",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Builds a list of ingredients
  Widget buildIngredientList(List<String> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Ingredients:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ...ingredients.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text("• $e"),
        )),
      ],
    );
  }

  // Filters suggestions based on user input
  void _updateSuggestions(String input) {
    setState(() {
      _filteredSuggestions = _suggestions
          .where((item) => item.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrilens'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView( // ✅ Fix overflow by wrapping with scroll view
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Search Bar + Suggestions
            Container(
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'product or ingredient',
                            border: InputBorder.none,
                          ),
                          onChanged: _updateSuggestions,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _analyzeSearch,
                      ),
                    ],
                  ),
                  if (_filteredSuggestions.isNotEmpty)
                    ..._filteredSuggestions.map((suggestion) => ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        _searchController.text = suggestion;
                        _filteredSuggestions.clear();
                        _analyzeSearch();
                      },
                    ))
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_healthScore != null)
              Center(
                child: buildHealthScoreBadge(_healthScore!),
              ),
            if (_matchedIngredients.isNotEmpty)
              buildIngredientList(_matchedIngredients),
            const SizedBox(height: 20),
            // Glossary Navigation Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/glossary');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Full Glossary",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.green),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/settings');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/notifications');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/search');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
