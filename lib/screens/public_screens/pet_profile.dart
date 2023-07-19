import 'package:flutter/material.dart';
import 'package:woofme/models/pet_info.dart';

class PetProfileScreen extends StatefulWidget {
  final PetInfo petInfo;
  const PetProfileScreen({Key? key, required this.petInfo}) : super(key: key);

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget aboutPet(PetInfo petInfo) {
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
            '${petInfo.name}',
            style: optionStyle,
          ),
          const SizedBox(height: 10),
          Text(
            '${petInfo.availability}',
            style: optionStyle,
          ),
          const SizedBox(height: 10),
          Text(
            '${petInfo.type} - ${petInfo.breed}',
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
          SizedBox(height: 40, child: Text('${petInfo.story}')),
          const SizedBox(height: 40),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    // final PetInfo petInfo =
    //     ModalRoute.of(context)?.settings.arguments as PetInfo;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Find Your Pawfect Match'),
        ),
        body: aboutPet(widget.petInfo));
    //   Padding(
    //   padding: const EdgeInsets.all(15.0),
    //   child: ListView(children: const [
    //     PetInfoBasic(),
    //     PetInfoMore(),
    //   ]),
    // ),
  }
}
