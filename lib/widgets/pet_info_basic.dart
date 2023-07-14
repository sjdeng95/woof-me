import 'package:flutter/material.dart';

import 'package:woofme/models/pet_info.dart';

class PetInfoBasic extends StatelessWidget {
  final PetInfo? petInfo;

  const PetInfoBasic({Key? key, this.petInfo}) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 400,
            child: Placeholder(),
          ),
          SizedBox(height: 10),
          Text(
            'PET NAME',
            style: optionStyle,
          ),
          SizedBox(height: 10),
          Text(
            'AGE',
            style: optionStyle,
          ),
          SizedBox(height: 10),
          Text(
            'Type - Breed',
            style: optionStyle,
          ),
          SizedBox(height: 20),
        ]);
  }
}
