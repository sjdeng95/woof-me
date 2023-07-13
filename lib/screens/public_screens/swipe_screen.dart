import 'package:flutter/material.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() =>
      _SwipeScreenState();
}

class _SwipeScreenState
    extends State<SwipeScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Pawfect Match'),
      ),
      body: const Center(
        child: Text(
          'SWIPE SCREEN',
          style: optionStyle,
        ),
      ),
    ); 
  }
}