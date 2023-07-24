import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Woof-Me'),
      ),
      body:
          const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'ALL USERS SCREEN',
          style: optionStyle,
        ),
      ]),
    );
  }
}
