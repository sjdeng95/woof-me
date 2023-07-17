import 'package:flutter/material.dart';
import 'package:woofme/widgets/pet_info_basic.dart';
import 'package:woofme/widgets/pet_info_more.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Pawfect Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(children: const [
          PetInfoBasic(),
          PetInfoMore(),
        ]),
      ),
    );
  }
}
