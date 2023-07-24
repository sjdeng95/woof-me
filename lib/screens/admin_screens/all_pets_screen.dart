import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllPetsScreen extends StatefulWidget {
  const AllPetsScreen({super.key});

  @override
  State<AllPetsScreen> createState() => _AllPetsScreenState();
}

class _AllPetsScreenState extends State<AllPetsScreen> {
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
          'ALL PETS',
          style: optionStyle,
        ),
      ]),
    );
  }
}
