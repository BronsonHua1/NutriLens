import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrilens'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Text color
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          // Notifications
          ListTile(
            title: const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          const Divider(),

          // Language
          ListTile(
            title: const Text(
              'Language',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
          const Divider(),

          // Theme
          ListTile(
            title: const Text(
              'Theme',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/theme');
            },
          ),
          const Divider(),

          // Dietary Preferences
          ListTile(
            title: const Text(
              'Dietary Preferences',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/dietary_preferences');
            },
          ),
          const Divider(),

          // User Guide
          ListTile(
            title: const Text(
              'User Guide',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/user_guide');
            },
          ),
          const Divider(),

          // Support
          ListTile(
            title: const Text(
              'Support',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/support');
            },
          ),
          const Divider(),

          // Change Password
          ListTile(
            title: const Text(
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
