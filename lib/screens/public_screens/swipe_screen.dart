import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:woofme/models/pet_info.dart';
import 'package:woofme/models/all_pets.dart';
import 'package:flutter/cupertino.dart';
import 'package:woofme/screens/public_screens/pet_profile.dart';
import 'package:woofme/widgets/pet_info_basic.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  AllPets allPets = AllPets();

  PetInfo pet = PetInfo();

  final AppinioSwiperController controller = AppinioSwiperController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  final _collectionRef = FirebaseFirestore.instance
      .collection('pets')
      .where('availability', isEqualTo: "Available");

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
            // allPets.pets.removeWhere((pets) => pets.petId == petInfo.petId);
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
        body: Column(
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
                      cardsBuilder: (BuildContext context, int index) {
                        // petId = allPets.pets[index].petId!;
                        pet = allPets.pets[index];
                        return buildPet(petInfo: allPets.pets[index]);
                      },
                    ))),
            // add space between swipe cards and swipe options
            const SizedBox(height: 70),
            swipeOptions(petInfo: pet)
          ],
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
