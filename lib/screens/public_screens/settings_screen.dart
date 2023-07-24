import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Signed in as ${user.email}',
          style: optionStyle,
        ),
        const SizedBox(height: 20.0),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50.0)),
            icon: const Icon(Icons.lock, size: 30),
            label: const Text('Sign Out'),
            onPressed: () {})
      ]),
    );
  }
}
