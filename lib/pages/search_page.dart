import 'package:flutter/material.dart';
import '../services/color_theme_service.dart';
import '../theme/theme_colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrilens'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ThemeColor.background,
        foregroundColor: ThemeColor.textPrimary,
      ),
      body: Container(
        color: ThemeColor.background, // <-- Set the dynamic background color here
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Container(
                decoration: BoxDecoration(
                  color: ThemeColor.secondary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu,
                      color: ThemeColor.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'product or ingredient',
                          hintStyle: TextStyle(color: ThemeColor.textPrimary),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: ThemeColor.textPrimary), // Optional: text color match
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      color: ThemeColor.textSecondary, 
                      onPressed: () {
                        // Add search logic here
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), 

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/glossary');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Full Glossary",
                    style: TextStyle(color: ThemeColor.textPrimary, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Small space between buttons

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_ingredients');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Add Ingredients",
                    style: TextStyle(color: ThemeColor.textPrimary, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ThemeColor.background,
        currentIndex: 3, // Index for Search Page
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: ThemeColor.textSecondary),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: ThemeColor.textSecondary),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: ThemeColor.textSecondary),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: ThemeColor.primary),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: ThemeColor.textSecondary),
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
