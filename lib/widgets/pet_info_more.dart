import 'package:flutter/material.dart';

import 'package:woofme/models/pet_info.dart';

class PetInfoMore extends StatelessWidget {
  final PetInfo? petInfo;

  const PetInfoMore({Key? key, required this.petInfo}) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          SizedBox(height: 40, child: Text('${petInfo!.story}')),
          const SizedBox(height: 40),
        ]);
  }
}
