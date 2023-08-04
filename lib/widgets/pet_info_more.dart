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
          title: Text("Good with other animals",
              style: Theme.of(context).textTheme.headlineSmall),
          value: petInfo!.goodAnimals,
          activeColor: Colors.green,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: Text("Good with children",
              style: Theme.of(context).textTheme.headlineSmall),
          value: petInfo!.goodChildren,
          activeColor: Colors.green,
          onChanged: (value) {},
        ),
        CheckboxListTile(
          title: Text("Must be on leash at all times",
              style: Theme.of(context).textTheme.headlineSmall),
          value: petInfo!.mustLeash,
          activeColor: Colors.green,
          onChanged: (value) {},
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 120,
            child: Text(
              '${petInfo!.story}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
