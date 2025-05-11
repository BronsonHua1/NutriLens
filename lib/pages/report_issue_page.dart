import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({Key? key}) : super(key: key);

  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

//state class for ReportIssuePage, handles the logic and UI state
class _ReportIssuePageState extends State<ReportIssuePage> {
  //controller for handling text input in description
  final TextEditingController _descriptionController = TextEditingController();
  //variable to hold currently selected report type
  String _reportType = 'Misinformation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), //padding for aesthetics
        child: ListView(
          children: <Widget>[
            //dropdownButton to allow user to select report type
            DropdownButton<String>(
              value: _reportType, //current selected value
              onChanged: (String? newValue) {
                setState(() {
                  _reportType = newValue ?? _reportType; //update state with new value
                });
              },
              items: <String>['Misinformation', 'Bugs', 'Missing Feature'] //dropdown menu types
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value, //value of item
                  child: Text(value), //text widget displaying item's value
                );
              }).toList(),
            ),
            //textField for user to enter detailed description of issue
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description', //label text for TextField
                hintText: 'Describe your issue or feedback', //hint text displayed when TextField is empty
              ),
              maxLines: 5, //allows for multiline text input
            ),
            //button to submit report
            ElevatedButton(
              onPressed: _submitReport, //method called when button is pressed
              child: const Text('Submit Report'), //text displayed on button
            ),
          ],
        ),
      ),
    );
  }

  //method to handle report submission
  void _submitReport() {
    final String message = _descriptionController.text; //get text from description TextField
    final String reportType = _reportType; //get current report type
    
    DatabaseReference ref = FirebaseDatabase.instance.ref('Feedback'); //firebase database reference

    //push new feedback entry to database
    ref.push().set({
      'Type': reportType, //type of the feedback
      'Message': message, //message of the feedback
      'Timestamp': DateTime.now().toIso8601String(), //timestamp of the feedback
    }).then((_) {
      //clear fields and navigate back with a success message on successful submission
      _descriptionController.clear(); //clear description TextField
      Navigator.pop(context); //pop current page off navigation stack
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')) //show success message
      );
    }).catchError((error) {
      //handle errors and show an error message if submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: $error')) //show error message
      );
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose(); //dispose controller when state is disposed
    super.dispose();
  }
}