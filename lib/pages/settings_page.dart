import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/color_theme_service.dart';
import '../theme/theme_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // 👇 This line is critical to trigger rebuilds when theme changes
    Provider.of<ColorThemeProvider>(context);

    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ThemeColor.textPrimary),
        title: Text('Nutrilens', style: TextStyle(color: ThemeColor.textPrimary)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ThemeColor.background,
        foregroundColor: ThemeColor.textPrimary, // Text color
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          // Notifications
          ListTile(
            title: Text(
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColor.textPrimary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          const Divider(),

          // Language
          ListTile(
            title: Text(
              'Language',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColor.textPrimary,
              ),

            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
          const Divider(),

          // Theme
          ListTile(
            title: Text(
              'Theme',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColor.textPrimary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/theme');
            },
          ),
          const Divider(),

          // Dietary Preferences
          ListTile(
            title: Text(
              'Dietary Preferences',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColor.textPrimary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/dietary_preferences');
            },
          ),
          const Divider(),

          // User Guide
          ListTile(
            title: Text(
              'User Guide',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColor.textPrimary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/user_guide');
            },
          ),
          const Divider(),

          // Support
          ListTile(
            title: Text(
              'Support',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColor.textPrimary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/support');
            },
          ),
          const Divider(),

          // Change Password
          ListTile(
            title: Text(
              'Change Password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColor.textPrimary,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/change_password');
            },
          ),
          const Divider(),

          // Log out
          ListTile(
            title: const Text(
              'Log out',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ThemeColor.background,
        currentIndex: 0, // Index for Settings Page
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.green),
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
