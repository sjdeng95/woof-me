import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:woofme/models/pet_info.dart';
import 'package:woofme/models/all_pets.dart';
import 'package:woofme/screens/public_screens/pet_profile.dart';

import '../../utils/misc_functions.dart';
import '../../utils/pet_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  AllPets allPets = AllPets();

  PetInfo pet = PetInfo();

  @override
  void initState() {
    super.initState();
    getData();
  }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('pets');


Future<void> getData() async {
  QuerySnapshot querySnapshot = await _collectionRef.get();

  final petInfo = querySnapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Convert document snapshot into a Map

    return PetInfo(
        name: data['name'] ?? '',
        type: capitalize(data['type'] ?? ''),
        breed: capitalize(data['breed'] ?? ''),
        availability: data['availability'] ?? 'Unavailable',
        goodAnimals: data['good_w_animals'] ?? false,
        goodChildren: data['good_w_children'] ?? false,
        mustLeash: data['must_leash'] ?? false,
        story: data['story'] ?? '',
        pic: data['pic'] ?? '');
  }).toList();

  setState(() {
    allPets = AllPets(pets: petInfo);
    if (allPets.pets.isNotEmpty) {
      pet = allPets.pets[0];
    }
  });
}

  Widget _buildPet(BuildContext context, PetInfo pet) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          height: double.infinity,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              '${pet.pic}',
            ),
          ),
        ),
        title: Text('${pet.name}', style: optionStyle),
        subtitle: Row(
          children: [Text('${pet.type} - ${pet.breed}')],
        ),
        trailing: SizedBox(
            height: double.infinity,
            child: petStatus(status: pet.availability!)),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PetProfileScreen(petInfo: pet))));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Woof-Me'),
        ),
        body: ListView.builder(
          itemCount: allPets.numberOfPets,
          itemBuilder: (context, index) =>
              _buildPet(context, allPets.pets[index]),
        ));
  }
}
