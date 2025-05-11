import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrilens'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ThemeColor.background,
        foregroundColor: ThemeColor.textPrimary, // Text color
      ),
      body: Container(
        color: ThemeColor.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              Icon(
                Icons.camera_alt_outlined, // Camera icon
                size: 150,
                color: ThemeColor.textSecondary,
              ),
              SizedBox(height: 20),
              Text(
                'Scan now!',
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ThemeColor.background,
        currentIndex: 2, // Index of the HomePage
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
            icon: Icon(Icons.home, color: ThemeColor.primary),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: ThemeColor.textSecondary),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: ThemeColor.textSecondary),
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
