import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'pages/health_metrics_page.dart';
import 'pages/login.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/search_page.dart';
import 'pages/notifications_page.dart';
import 'pages/language_page.dart';
import 'pages/theme_page.dart';
import 'pages/dietary_preferences_page.dart';
import 'pages/user_guide_page.dart';
import 'pages/support_page.dart';
import 'pages/change_password_page.dart';
import 'pages/profile_page.dart';
import 'pages/ingredients_profile_page.dart';
import 'pages/calorie_goal_page.dart';
import 'pages/history_log_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handles background notifications
  print("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set up background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(NutriLensApp());
}

class NutriLensApp extends StatefulWidget {
  const NutriLensApp({super.key});

  @override
  _NutriLensAppState createState() => _NutriLensAppState();
}

class _NutriLensAppState extends State<NutriLensApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
    _initializeFirebaseMessaging();
  }

  /// Request notification permission from the user
  void _requestNotificationPermission() async {
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

  /// Initialize Firebase Messaging for foreground and background notifications
  void _initializeFirebaseMessaging() {
    // Get FCM Token
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    // Handle notifications when the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received notification: ${message.notification?.title}");
    });

    // Handle notification tap when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User opened the app from a notification: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriLens',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
        '/search': (context) => SearchPage(),
        '/notifications': (context) => NotificationsPage(),
        '/language': (context) => LanguagePage(),
        '/theme': (context) => ThemePage(),
        '/dietary_preferences': (context) => DietaryPreferencesPage(),
        '/user_guide': (context) => UserGuidePage(),
        '/support': (context) => SupportPage(),
        '/change_password': (context) => ChangePasswordPage(),
        '/profile': (context) => ProfilePage(),
        '/ingredients_profile': (context) => IngredientsProfilePage(),
        '/calorie_goal': (context) => CalorieGoalPage(),
        '/health_metrics': (context) => HealthMetricsPage(),
        '/history_log': (context) => HistoryLogPage(),
      },
    );
  }
}
