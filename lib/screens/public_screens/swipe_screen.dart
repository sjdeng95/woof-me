import 'package:flutter/material.dart';
import 'pet_profile.dart';
import 'package:woofme/widgets/pet_info_basic.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Pawfect Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const PetProfileScreen())));
                  },
                  onHorizontalDragEnd: (details) {},
                  child: const PetInfoBasic()),
              swipeOptions()
            ]),
      ),
    );
  }

  ButtonBar swipeOptions() {
    return ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 50.0),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.cancel, size: 50.0),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_rounded, size: 50.0),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 50.0),
            onPressed: () {},
          ),
        ]);
  }
}
