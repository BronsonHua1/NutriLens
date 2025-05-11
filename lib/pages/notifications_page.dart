import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/notification_service.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import '../theme/theme_colors.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 1; // Set to 1 because this is the notifications page

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Prevents unnecessary rebuilds

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case 1:
      // Stay on the Notifications Page
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SearchPage()));
        break;
      case 4:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var notificationService = Provider.of<NotificationService>(context);

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
        child: notificationService.notifications.isEmpty
            ? Center(
                child: Text(
                  "No new notifications",
                  style: TextStyle(
                    color: ThemeColor.textPrimary, 
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: notificationService.notifications.length,
                itemBuilder: (context, index) {
                  RemoteMessage message = notificationService.notifications[index];
                  return Card(
                    color: ThemeColor.background.withOpacity(0.9),
                    child: ListTile(
                      title: Text(
                        message.notification?.title ?? "No Title",
                        style: TextStyle(
                          color: ThemeColor.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        message.notification?.body ?? "No Content",
                        style: TextStyle(
                          color: ThemeColor.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          notificationService.deleteNotification(index);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ThemeColor.background,
        items: const <BottomNavigationBarItem>[
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
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ThemeColor.primary, // Change color as needed
        unselectedItemColor: ThemeColor.textSecondary,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
