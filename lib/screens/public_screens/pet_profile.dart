import 'package:flutter/material.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Pawfect Match'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 400,
                  child: Placeholder(),
                ),
                const SizedBox(height: 10),
                const Text(
                  'PET NAME',
                  style: optionStyle,
                ),
                const SizedBox(height: 10),
                const Text(
                  'AGE',
                  style: optionStyle,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Type - Breed',
                  style: optionStyle,
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text("Good with other animals"),
                  value: true,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  title: const Text("Good with children"),
                  value: true,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  title: const Text("Must be on leash at all times"),
                  value: true,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 40),
                const Text('Pet short story goes here.')
              ]),
        ),
      ),
    );
  }
}
