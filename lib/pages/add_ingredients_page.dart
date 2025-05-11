import 'package:flutter/material.dart';
import '../services/local_ingredient_database_service.dart';

//stateful widget for adding and displaying ingredients
class AddIngredientsPage extends StatefulWidget {
  const AddIngredientsPage({super.key});

  @override
  _AddIngredientsPageState createState() => _AddIngredientsPageState();
}

class _AddIngredientsPageState extends State<AddIngredientsPage> {
  //controllers for text fields to get user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _healthRatingController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  //list to store loaded ingredients from database
  List<Map<String, dynamic>> _ingredients = [];

  @override
  void initState() {
    super.initState();
    _loadIngredients(); //load existing ingredients when page opens
  }

  //fetch ingredients from local SQLite database
  Future<void> _loadIngredients() async {
    final ingredients = await IngredientDatabase.instance.getIngredients();
    setState(() {
      _ingredients = ingredients;
    });
  }

  //add a new ingredient to database
  Future<void> _addIngredient() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final healthRatingText = _healthRatingController.text.trim();
    final category = _categoryController.text.trim();

    //validate that all fields are filled
    if (name.isNotEmpty && description.isNotEmpty && healthRatingText.isNotEmpty && category.isNotEmpty) {
      final healthRating = int.tryParse(healthRatingText); //parse rating into an integer
      if (healthRating != null) {
        //insert ingredient into database
        await IngredientDatabase.instance.insertIngredient(
          name: name,
          description: description,
          healthRating: healthRating,
          category: category,
        );

        //clear form fields
        _nameController.clear();
        _descriptionController.clear();
        _healthRatingController.clear();
        _categoryController.clear();

        _loadIngredients(); //reload the list to show new ingredient
      } else {
        //show error if health rating is not a valid number
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
        backgroundColor: Colors.green, //app bar background
        foregroundColor: Colors.white,  //app bar text color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //form fields for entering ingredient information
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _healthRatingController,
              decoration: const InputDecoration(labelText: 'Health Rating (1-10)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 20),

            //button to submit new ingredient
            ElevatedButton(
              onPressed: _addIngredient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Add Ingredient',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            //list displaying all ingredients
            Expanded(
              child: ListView.builder(
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _ingredients[index];
                  return ListTile(
                    title: Text(ingredient['name']),
                    subtitle: Text('Health Rating: ${ingredient['healthRating']} - ${ingredient['category']}'),
                    onTap: () {
                      _showIngredientDetails(ingredient); //show details and allow deletion
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //show a popup dialog with full ingredient details
  void _showIngredientDetails(Map<String, dynamic> ingredient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ingredient['name']),
        content: Text(
          'Description: ${ingredient['description']}\n\n'
          'Health Rating: ${ingredient['healthRating']}\n\n'
          'Category: ${ingredient['category']}',
        ),
        actions: [
          //close dialog
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          //delete ingredient
          TextButton(
            onPressed: () async {
              await IngredientDatabase.instance.deleteIngredient(ingredient['id']);
              Navigator.pop(context);
              _loadIngredients(); //reload list after deletion
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
