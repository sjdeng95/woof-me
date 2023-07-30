import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:woofme/models/pet_info.dart';
import 'package:woofme/models/all_pets.dart';
import 'package:flutter/cupertino.dart';
import 'package:woofme/screens/public_screens/pet_profile.dart';
import 'package:woofme/widgets/pet_info_basic.dart';

import '../../utils/misc_functions.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  AllPets allPets = AllPets();
  PetInfo pet = PetInfo();

  final AppinioSwiperController controller = AppinioSwiperController();
  final CollectionReference _usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    DocumentSnapshot userDoc = await _usersCollectionRef.doc(currentUser.email).get();
    List<String> likedPetsIds = List<String>.from(userDoc['liked_pets']);
    List<String> dislikedPetsIds = List<String>.from(userDoc['disliked_pets']);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('pets')
        .where('availability', whereIn: ["Available", "Pending"])
        .get();

    final petInfo = querySnapshot.docs.where((doc) {
      return !likedPetsIds.contains(doc.id) && !dislikedPetsIds.contains(doc.id);
    }).map((doc) {
      return PetInfo(
          petId: doc.id,
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

  Widget buildPet({required PetInfo petInfo}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetProfileScreen(petInfo: petInfo),
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: PetInfoBasic(petInfo: petInfo),
        ),
      ),
    );
  }

  Widget swipeOptions({required PetInfo petInfo}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton.icon(
          icon: const Icon(Icons.close_rounded, size: 35.0, color: Colors.red),
          label: const Text('Dislike', style: TextStyle(color: Colors.black)),
          onPressed: () {
            controller.swipeLeft();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.undo_rounded, size: 35.0, color: Colors.grey),
          label: const Text('Undo', style: TextStyle(color: Colors.black)),
          onPressed: () {
            controller.unswipe();
            _unswipe(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.favorite_rounded,
              size: 35.0, color: Colors.pinkAccent),
          label: const Text('Like', style: TextStyle(color: Colors.black)),
          onPressed: () {
            controller.swipeRight();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Pawfect Match'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _usersCollectionRef.doc(currentUser.email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<String> likedPets = List<String>.from(snapshot.data!['liked_pets']);
            List<String> dislikedPets = List<String>.from(snapshot.data!['disliked_pets']);
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('pets')
                  .where('availability', whereIn: ["Available", "Pending"])
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> petSnapshot) {
                if (petSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  allPets = AllPets(pets: petSnapshot.data!.docs.where((doc) {
                    return !likedPets.contains(doc.id) && !dislikedPets.contains(doc.id);
                  }).map((doc) {
                    return PetInfo(
                        petId: doc.id,
                        name: doc['name'],
                        type: capitalize(doc['type']),
                        breed: capitalize(doc['breed']),
                        availability: doc['availability'],
                        goodAnimals: doc['good_w_animals'],
                        goodChildren: doc['good_w_children'],
                        mustLeash: doc['must_leash'],
                        story: doc['story'],
                        pic: doc['pic']);
                  }).toList());
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CupertinoPageScaffold(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.60,
                              width: double.infinity,
                              child: AppinioSwiper(
                                cardsCount: allPets.numberOfPets,
                                controller: controller,
                                loop: true,
                                padding: const EdgeInsets.all(0),
                                onSwipe: (int index, AppinioSwiperDirection direction) {
                                  lastPetId = pet.petId;
                                  if (direction == AppinioSwiperDirection.left) {
                                    _usersCollectionRef.doc(currentUser.email).update({
                                      'disliked_pets': FieldValue.arrayUnion([pet.petId])
                                    });
                                  }
                                  if (direction == AppinioSwiperDirection.right) {
                                    _usersCollectionRef.doc(currentUser.email).update({
                                      'liked_pets': FieldValue.arrayUnion([pet.petId])
                                    });
                                  }
                                },
                                unswipe: _unswipe,
                                cardsBuilder: (BuildContext context, int index) {
                                  pet = allPets.pets[index];
                                  return buildPet(petInfo: allPets.pets[index]);
                                },
                              ))),

                      const SizedBox(height: 70),
                      swipeOptions(petInfo: pet)
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
  String? lastPetId;

  void _unswipe(bool unswiped) {
    if (unswiped) {
      if (lastPetId != null) {
        _usersCollectionRef.doc(currentUser.email).update({
          'liked_pets': FieldValue.arrayRemove([lastPetId!]),
          'disliked_pets': FieldValue.arrayRemove([lastPetId!])
        });
        lastPetId = null;
      }
    } else {
      debugPrint("FAIL: no card left to unswipe.");
    }
  }
}

