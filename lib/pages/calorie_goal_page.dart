import 'package:flutter/material.dart';
import '../components/text_field_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CalorieGoalPage extends StatelessWidget {
  final goalController = TextEditingController();

  CalorieGoalPage({super.key});

  void addCalorieGoal(String input) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${user.uid}");
      await ref.update({
        "Calorie Goal" : input,
      });
    }
  }

  Future<String?> getCalorieGoal() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Users/${user.uid}");
      var snapshot = await ref.child('Calorie Goal').get();
      if (snapshot.exists) {
        return snapshot.value.toString();
      }
    }
    return "None";
  }

  Future<void> inputCalorieGoal(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
      return AlertDialog(
        title: Text('Enter Calorie Goal'),
        content: TextFieldFab(controller: goalController, hintText: 'Daily Calories', obscureText: false),
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
              addCalorieGoal(goalController.text);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalorieGoalPage()));
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
        title: const Text('Calorie Goal'),
      ),
      body: Center(
        child:
        Column(
        children: [
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
          TextButton(
            onPressed: () {
            inputCalorieGoal(context);
          },
          child: const Text('Add Calorie Goal'),
      ),
    ])));
  }


}
