import 'package:flutter/material.dart';

import '../../widgets/pet_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAVORITES'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(children: const [
          PetWidget()
        ]),
      ),
    );
  }
}