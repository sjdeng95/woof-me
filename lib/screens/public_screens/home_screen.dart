import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:woofme/models/pet_info.dart';
import 'package:woofme/models/all_pets.dart';
import 'package:woofme/screens/public_screens/pet_profile.dart';

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
      return PetInfo(
          name: doc['name'],
          type: capitalize(doc['type']),
          breed: capitalize(doc['breed']),
          availability: doc['availability'],
          goodAnimals: doc['good_w_animals'],
          goodChildren: doc['good_w_children'],
          mustLeash: doc['must_leash'],
          story: doc['story'],
          pic: doc['pic']);
    }).toList();
    setState(() {
      allPets = AllPets(pets: petInfo);
      pet = allPets.pets[0];
    });
  }

  Widget _buildPet(BuildContext context, PetInfo pet) {
    return Card(
      child: ListTile(
        leading:
            const SizedBox(height: double.infinity, child: Icon(Icons.pets)),
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

  Icon petStatus({required String status}) {
    if (status == 'Available') {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (status == 'Not Available') {
      return const Icon(Icons.not_interested, color: Colors.red);
    } else if (status == 'Pending') {
      return const Icon(Icons.pending_outlined, color: Colors.deepOrange);
    } else if (status == 'Adopted') {
      return const Icon(Icons.done_all, color: Colors.blue);
    } else {
      return const Icon(Icons.question_mark, color: Colors.grey);
    }
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

String capitalize(String input) {
  if (input.isEmpty) return '';
  return input
      .split(' ')
      .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
      .join(' ');
}