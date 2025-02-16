import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      _notifications.insert(0, message); // Add to list
      notifyListeners(); // Notify UI to update
    });

    // Handle notification tap when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notifications.insert(0, message);
      notifyListeners();

      // Navigate to Notifications Page
      navigatorKey.currentState?.pushNamed('/notifications');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Delete a notification by index
  void deleteNotification(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners(); // Update UI after deletion
    }
  }

  /// Background message handler (must be static)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
  }
}
