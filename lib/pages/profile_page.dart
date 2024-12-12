import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});  

  @override
  ProfilePageState createState() => ProfilePageState();  
}

class ProfilePageState extends State<ProfilePage> {  
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
