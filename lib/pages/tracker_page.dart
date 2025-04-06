import 'package:flutter/material.dart';
import '../components/text_field_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nutrilens/pages/calorie_goal_page.dart';
import 'package:intl/intl.dart';

class TrackerPage extends StatelessWidget {
  final calorieController = TextEditingController();
  final proteinController = TextEditingController();
  final carbController = TextEditingController();
  final fatController = TextEditingController();

  TrackerPage({super.key});

  // Function that adds a meal to the real time database using the current time as the key
  void addMeal(String calorieInput, String proteinInput, String carbInput, String fatInput) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${user.uid}/Meals");
      String dateTime = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      await ref.update({
        dateTime : {
          "Calories": calorieInput,
          "Protein (g)": proteinInput,
          "Carbs (g)": carbInput,
          "Fats (g)": fatInput
        }
      });
    }
  }

  // Returns a pair: a string containing all the meals tracked with information, a int containing the total amount of calories tracked
  Future<List<dynamic>> getMeals() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref(
          "Users/${user.uid}/Meals");
      var snapshot = await ref.get();
      String result = "";
      int totalCalories = 0;
      for (DataSnapshot meal in snapshot.children) { // Loops through all the meals contained in a person's profile
        String datetime = meal.key.toString();
        String calories = meal
            .child("Calories")
            .value
            .toString();
        totalCalories += int.parse(calories);
        String protein = meal
            .child("Protein (g)")
            .value
            .toString();
        String carbs = meal
            .child("Carbs (g)")
            .value
            .toString();
        String fats = meal
            .child("Fats (g)")
            .value
            .toString();

        String output = "\nDateTime: $datetime, \n\tCalories: $calories, \n\tProtein: $protein g, \n\tCarbs: $carbs g, \n\tFats: $fats g\n";
        result = "$output$result";
      }
      return [result, totalCalories];
    }
    return ["None", 0];
  }

  // Prompts the user with a window that handles inputs for calories, protein, carbs, and fats for tracking meal information
  Future<void> inputMeal(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Enter Meal Information'),
              content: SingleChildScrollView(
                child: ListBody (
                children: [
                  TextFieldFab(controller: calorieController, hintText: 'Calories', obscureText: false),
                  SizedBox(height: 12),
                  TextFieldFab(controller: proteinController, hintText: 'Protein (g)', obscureText: false),
                  SizedBox(height: 12),
                  TextFieldFab(controller: carbController, hintText: 'Carbs (g)', obscureText: false),
                  SizedBox(height: 12),
                  TextFieldFab(controller: fatController, hintText: 'Fats (g)', obscureText: false)
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Submit'),
                  onPressed: () {
                    addMeal(calorieController.text, proteinController.text, carbController.text, fatController.text);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackerPage()));
                  },
                )
              ]
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meals'), // Change to display previously entered items
        ),
        body: Center(
            child:
            Column(
                children: [
                  TextButton(
                    onPressed: () {
                      inputMeal(context);
                    },
                    child: const Text('Add Meal'),
                  ),
                  FutureBuilder(
                      future: getCalorieGoal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text(
                            snapshot.error.toString(),
                          );
                        }
                        else {
                          return Text(
                              'Current Calorie Goal : ${snapshot.data.toString()}'
                          );
                        }
                      }
                  ),
                  FutureBuilder(
                      future: getMeals(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text(
                            snapshot.error.toString(),
                          );
                        }
                        else {
                          return Text(
                              'Tracked Calories : ${snapshot.data?[1].toString()}\n\nTracked Meals : ${snapshot.data?[0].toString()}'
                          );
                        }
                      }
                  ),
                ])));
  }


}
