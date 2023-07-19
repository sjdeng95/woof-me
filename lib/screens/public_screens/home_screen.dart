import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:woofme/models/pet_info.dart';
import 'package:woofme/screens/public_screens/pet_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget _buildPet(BuildContext context, DocumentSnapshot docs) {
    return Card(
      child: ListTile(
        leading:
            const SizedBox(height: double.infinity, child: Icon(Icons.pets)),
        title: Text(docs['name'], style: optionStyle),
        subtitle: Row(
          children: [
            Text(docs['type']),
            const Text(' - '),
            Text(docs['breed'])
          ],
        ),
        trailing: const SizedBox(
            height: double.infinity, child: Icon(Icons.more_vert)),
        isThreeLine: true,
        onTap: () {
          PetInfo petInfo = PetInfo(
            name: docs['name'],
            type: docs['type'],
            breed: docs['breed'],
            availability: docs['availability'],
            goodAnimals: docs['good_w_animals'],
            goodChildren: docs['good_w_children'],
            mustLeash: docs['must_leash'],
            story: docs['story'],
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PetProfileScreen(petInfo: petInfo))));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Woof-Me'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('pets')
              .orderBy('created_at')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('No pets');
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  _buildPet(context, snapshot.data!.docs[index]),
            );
          },
        ));
  }
}
