import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Container(
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  const Icon(Icons.menu),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'product or ingredient',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Add search logic here
                    },
                  ),
                ],
              ),
            ),
             // Space between search bar and button
            const SizedBox(height: 20), 

            // New button to navigate to another page
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/glossary'); // Change to your route
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Index for Search Page
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
            Navigator.pushNamed(context, '/settings'); // Navigate to Settings
          } else if (index == 1) {
            Navigator.pushNamed(context, '/notifications');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/home'); // Navigate to Home
          } else if (index == 3) {
            Navigator.pushNamed(context, '/search'); // Stay on Search Page
          } else if (index == 4) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
