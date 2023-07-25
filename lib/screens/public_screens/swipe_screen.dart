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


  AllPets allPets = AllPets();

  PetInfo pet = PetInfo();

  final AppinioSwiperController controller = AppinioSwiperController();

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
  }

  Widget buildPet({required PetInfo petInfo}) {
    return GestureDetector(
        child: Card(
          color: Colors.white,
          child: PetInfoBasic(petInfo: petInfo),
        ),
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          PetProfileScreen(petInfo: petInfo))))
            });
  }

  Widget swipeOptions({required PetInfo petInfo}) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: const Icon(Icons.cancel, size: 75.0, color: Colors.red),
        onPressed: () {
          // allPets.pets.removeWhere((pets) => pets.petId == petInfo.petId);
        },
      ),
      IconButton(
        icon: const Icon(Icons.check_circle, size: 75.0, color: Colors.green),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.undo_rounded, size: 75.0, color: Colors.grey),
        onPressed: () {},
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoPageScaffold(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: AppinioSwiper(
                  cardsCount: allPets.numberOfPets,
                  controller: controller,
                  loop: true,
                  padding: const EdgeInsets.all(20.0),
                  cardsBuilder: (BuildContext context, int index) {
                    // petId = allPets.pets[index].petId!;
                    pet = allPets.pets[index];
                    return buildPet(petInfo: allPets.pets[index]);
                  },
                ))),
        swipeOptions(petInfo: pet)
      ],
    );
  }
}
