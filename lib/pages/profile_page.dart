import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});  // Using super parameter for key

  @override
  ProfilePageState createState() => ProfilePageState();  // Using public state class
}

class ProfilePageState extends State<ProfilePage> {  // Changed from private to public
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: const Center(
        child: Text('This is the Profile Page'),
      ),
    );
  }
}
