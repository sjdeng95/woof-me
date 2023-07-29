import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woofme/screens/public_screens/pet_profile.dart';

import '../../models/pet_info.dart';
import '../../utils/misc_functions.dart';
import '../../utils/pet_status.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final CollectionReference _petsCollectionRef =
  FirebaseFirestore.instance.collection('pets');

  final CollectionReference _usersCollectionRef =
  FirebaseFirestore.instance.collection('Users');

  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _usersCollectionRef.doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No favorite pets found'));
          }

          final userDoc = snapshot.data!;
          List<String> likedPetsIds = List<String>.from(userDoc['liked_pets']);

          return ListView.builder(
            itemCount: likedPetsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                  future: _petsCollectionRef.doc(likedPetsIds[index]).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      // Delete from liked pets if pet document doesn't exist
                      _usersCollectionRef.doc(currentUser.email).update({
                        'liked_pets': FieldValue.arrayRemove([likedPetsIds[index]])
                      });
                    }
                    PetInfo pet = PetInfo(
                        name: snapshot.data!['name'],
                        type: capitalize(snapshot.data!['type']),
                        breed: capitalize(snapshot.data!['breed']),
                        availability: snapshot.data!['availability'],
                        goodAnimals: snapshot.data!['good_w_animals'],
                        goodChildren: snapshot.data!['good_w_children'],
                        mustLeash: snapshot.data!['must_leash'],
                        story: snapshot.data!['story'],
                        pic: snapshot.data!['pic']
                    );
                    return _buildPet(context, pet, likedPetsIds[index]);
                  });
            },
          );
        },
      ),
    );
  }

  Widget _buildPet(BuildContext context, PetInfo pet, String petId) {
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: Text("Are you sure you want to remove ${pet.name} from your favorites?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("CANCEL"),
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss dialog
                          },
                        ),
                        TextButton(
                          child: const Text("REMOVE"),
                          onPressed: () {
                            _usersCollectionRef.doc(currentUser.email).update({
                              'liked_pets': FieldValue.arrayRemove([petId])
                            });
                            Navigator.of(context).pop(); // Dismiss dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            petStatus(status: pet.availability!)
          ],
        ),
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
}