import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

//stateful widget to display user history
class HistoryLogPage extends StatefulWidget {
  const HistoryLogPage({super.key});

  @override
  State<HistoryLogPage> createState() => _HistoryLogPageState();
}

class _HistoryLogPageState extends State<HistoryLogPage> {
  //reference to the user's history data in Firebase Realtime Database
  final DatabaseReference _historyRef = FirebaseDatabase.instance.ref('HistoryLog/User1');

  //stores all the history entries after loading from Firebase
  Map<String, dynamic> _historyData = {};

  //used to track which entry is currently expanded in the list
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadHistory(); //load data from Firebase when the widget is first created
  }

  //loads history data from Firebase once
  void _loadHistory() async {
    final event = await _historyRef.once();

    //if data exists, convert to map and store it in state
    if (event.snapshot.exists) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        _historyData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //extract and sort date keys in descending order (most recent first)
    final List<String> dates = _historyData.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Log'),
        backgroundColor: Colors.green, //theme color for AppBar
      ),
      body: _historyData.isEmpty
          ? const Center(child: CircularProgressIndicator()) //show loading spinner while fetching
          : ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final date = dates[index]; //timestamp used as key
                final entry = Map<String, dynamic>.from(_historyData[date]); //single history entry
                final isExpanded = _expandedIndex == index; //checks if this tile is expanded

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text(entry['Product'] ?? 'Unknown Product'), //product name
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(date), //date of scan
                        if (isExpanded) const SizedBox(height: 8),
                        if (isExpanded)
                          Text("Ingredients: ${entry['Ingredients'] ?? 'Unknown'}"), //expanded info
                        if (isExpanded)
                          Text("Overall Health Score: ${entry['Overall Health Score'] ?? 'N/A'}"), //score
                      ],
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more, //toggle arrow
                    ),
                    onTap: () {
                      setState(() {
                        //toggle expansion on tap
                        _expandedIndex = isExpanded ? null : index;
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
