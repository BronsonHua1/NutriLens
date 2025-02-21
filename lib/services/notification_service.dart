import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final NotificationService _instance = NotificationService._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  List<RemoteMessage> _notifications = [];
  List<RemoteMessage> get notifications => _notifications;

  /// Initialize Firebase and set up notifications
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _requestNotificationPermission();
    _setupFirebaseMessagingHandlers();
  }

  /// Request user permission for notifications
  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("User declined notifications");
    } else {
      print("User granted notification permission");
    }
  }

  /// Set up handlers for Firebase notifications
  void _setupFirebaseMessagingHandlers() {
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _notifications.insert(0, message);
      notifyListeners(); // Update UI

      // Show a small alert when a notification appears
      _showNotificationAlert(message);
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notifications.insert(0, message);
      notifyListeners();
      navigatorKey.currentState?.pushNamed('/notifications');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Show a Snackbar alert when a notification arrives in the foreground
  void _showNotificationAlert(RemoteMessage message) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message.notification?.title ?? "New Notification"),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              navigatorKey.currentState?.pushNamed('/notifications');
            },
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  /// Delete a notification by index
  void deleteNotification(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners(); // Update UI after deletion
    }
  }

  /// Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners(); // Update UI after clearing all notifications
  }



  /// Background message handler (must be static)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
  }
}
