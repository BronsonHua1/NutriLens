import 'package:flutter/material.dart';
import '../services/local_ingredient_database_service.dart';

class AddIngredientsPage extends StatefulWidget {
  const AddIngredientsPage({super.key});

  @override
  _AddIngredientsPageState createState() => _AddIngredientsPageState();
}

class _AddIngredientsPageState extends State<AddIngredientsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _healthRatingController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _commonUsesController = TextEditingController();
  final TextEditingController _dietaryTagsController = TextEditingController();
  final TextEditingController _healthImpactController = TextEditingController();
  final TextEditingController _warningsController = TextEditingController();

  bool _allergenRisk = false;
  final List<String> _allAvailableAllergens = [
    "Peanut", "Tree nut", "Milk", "Wheat", "Gluten", "Shrimp",
    "Shellfish", "Hazelnut", "Oats", "Legumes", "Chickpeas",
    "Mustard", "Sunflower seeds", "Banana"
  ];
  final Set<String> _selectedAllergens = {};

  List<Map<String, dynamic>> _ingredients = [];
  bool _showUploaded = false;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final ingredients = await IngredientDatabase.instance.getIngredients();
    setState(() {
      _ingredients = ingredients;
    });
  }

  Future<void> _addIngredient() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final healthRatingText = _healthRatingController.text.trim();
    final category = _categoryController.text.trim();
    final commonUses = _commonUsesController.text.trim().split(',');
    final dietaryTags = _dietaryTagsController.text.trim().split(',');
    final healthImpact = _healthImpactController.text.trim();
    final warnings = _warningsController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty && healthRatingText.isNotEmpty && category.isNotEmpty) {
      final healthRating = int.tryParse(healthRatingText);
      if (healthRating != null) {
        await IngredientDatabase.instance.insertIngredient(
          name: name,
          description: description,
          healthRating: healthRating,
          category: category,
          allergenRisk: _allergenRisk,
          allergenMatch: _selectedAllergens.toList(),
          commonUses: commonUses,
          dietaryTags: dietaryTags,
          healthImpact: healthImpact,
          warnings: warnings,
        );

        _nameController.clear();
        _descriptionController.clear();
        _healthRatingController.clear();
        _categoryController.clear();
        _commonUsesController.clear();
        _dietaryTagsController.clear();
        _healthImpactController.clear();
        _warningsController.clear();
        _selectedAllergens.clear();
        _allergenRisk = false;

        _loadIngredients();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Health Rating must be a number')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ingredients'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showUploaded = !_showUploaded;
                  });
                },
                child: Text(_showUploaded ? 'Hide Uploaded Ingredients' : 'View Uploaded Ingredients'),
              ),
              const SizedBox(height: 20),
              if (_showUploaded)
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = _ingredients[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(ingredient['name'] ?? 'Unnamed'),
                          subtitle: Text('Health Rating: ${ingredient['healthRating']} - ${ingredient['category']}'),
                          onTap: () => _showIngredientDetails(ingredient),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: _healthRatingController, decoration: const InputDecoration(labelText: 'Health Rating (1-10)'), keyboardType: TextInputType.number),
              TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category')),
              SwitchListTile(
                title: const Text('Allergen Risk'),
                value: _allergenRisk,
                onChanged: (val) => setState(() => _allergenRisk = val),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text('Select Allergens'),
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _allAvailableAllergens.map((allergen) {
                  return CheckboxListTile(
                    title: Text(allergen),
                    value: _selectedAllergens.contains(allergen.toLowerCase()),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedAllergens.add(allergen.toLowerCase());
                        } else {
                          _selectedAllergens.remove(allergen.toLowerCase());
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              TextField(controller: _commonUsesController, decoration: const InputDecoration(labelText: 'Common Uses (comma-separated)')),
              TextField(controller: _dietaryTagsController, decoration: const InputDecoration(labelText: 'Dietary Tags (comma-separated)')),
              TextField(controller: _healthImpactController, decoration: const InputDecoration(labelText: 'Health Impact')),
              TextField(controller: _warningsController, decoration: const InputDecoration(labelText: 'Warnings')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addIngredient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Add Ingredient', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIngredientDetails(Map<String, dynamic> ingredient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ingredient['name'] ?? 'No Name'),
        content: SingleChildScrollView(
          child: Text(
            'Description: ${ingredient['description'] ?? ''}\n\n'
            'Health Rating: ${ingredient['healthRating'] ?? ''}\n\n'
            'Category: ${ingredient['category'] ?? ''}\n\n'
            'Allergen Risk: ${ingredient['allergenRisk'] ?? ''}\n'
            'Allergen Match: ${(ingredient['allergenMatch'] as List?)?.join(", ") ?? ''}\n\n'
            'Common Uses: ${(ingredient['commonUses'] as List?)?.join(", ") ?? ''}\n'
            'Dietary Tags: ${(ingredient['dietaryTags'] as List?)?.join(", ") ?? ''}\n\n'
            'Health Impact: ${ingredient['healthImpact'] ?? ''}\n'
            'Warnings: ${ingredient['warnings'] ?? ''}',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          TextButton(
            onPressed: () async {
              await IngredientDatabase.instance.deleteIngredient(ingredient['id']);
              Navigator.pop(context);
              _loadIngredients();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
