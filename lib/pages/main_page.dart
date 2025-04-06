import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [HomePage(), SearchPage(), ProfilePage(), SettingsPage()];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout_rounded),)]),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_max_outlined), backgroundColor: Colors.black, label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), backgroundColor: Colors.black, label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), backgroundColor: Colors.black, label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), backgroundColor: Colors.black, label: 'Settings'),
        ],
      ),
    );
  }
}
