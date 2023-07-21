import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'dart:developer';
import 'package:woofme/models/pet_info.dart';
import 'package:woofme/models/all_pets.dart';
import 'package:flutter/cupertino.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  AllPets allPets = AllPets();

  late PetInfo pet;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget buildPet({required int index}) {
    return Card(
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 400,
                child: Placeholder(),
              ),
              const SizedBox(height: 10),
              Text(
                '${allPets.pets[index].name}',
                style: optionStyle,
              ),
              const SizedBox(height: 10),
              Text(
                '${allPets.pets[index].availability}',
                style: optionStyle,
              ),
              const SizedBox(height: 10),
              Text(
                '${allPets.pets[index].type} - ${allPets.pets[index].breed}',
                style: optionStyle,
              ),
              swipeOptions(),
            ]));
  }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('pets');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final petInfo = querySnapshot.docs.map((doc) {
      return PetInfo(
          name: doc['name'],
          type: doc['type'],
          breed: doc['breed'],
          availability: doc['availability'],
          goodAnimals: doc['good_w_animals'],
          goodChildren: doc['good_w_children'],
          mustLeash: doc['must_leash'],
          story: doc['story']);
    }).toList();
    setState(() {
      allPets = AllPets(pets: petInfo);
      pet = allPets.pets[0];
    });
    log(allPets as String);
    log(pet as String);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: AppinioSwiper(
              cardsCount: allPets.numberOfPets,
              onSwiping: (AppinioSwiperDirection direction) {
                log(direction.toString());
              },
              cardsBuilder: (BuildContext context, int i) {
                return buildPet(index: i);
              },
            )));
  }

  ButtonBar swipeOptions() {
    return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: const Icon(Icons.cancel, size: 50.0),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.favorite_rounded, size: 50.0),
        onPressed: () {},
      ),
    ]);
  }
}
