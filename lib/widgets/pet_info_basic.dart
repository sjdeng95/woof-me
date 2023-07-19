import 'package:flutter/material.dart';

import 'package:woofme/models/pet_info.dart';

class PetInfoBasic extends StatelessWidget {
  final PetInfo? petInfo;

  const PetInfoBasic({Key? key, this.petInfo}) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 400,
            child: Placeholder(),
          ),
          const SizedBox(height: 10),
          Text(
            '${petInfo!.name}',
            style: optionStyle,
          ),
          const SizedBox(height: 10),
          Text(
            '${petInfo!.availability}',
            style: optionStyle,
          ),
          const SizedBox(height: 10),
          Text(
            '${petInfo!.type} - ${petInfo!.breed}',
            style: optionStyle,
          ),
          const SizedBox(height: 20),
        ]);
  }
}
