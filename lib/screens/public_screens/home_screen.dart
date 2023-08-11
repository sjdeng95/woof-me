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
  AllPets allPets = AllPets();
  PetInfo pet = PetInfo();
  List<PetInfo> allPetsData = [];

  String? typeFilter;
  String? breedFilter;

  @override
  void initState() {
    super.initState();
    getData();
  }

  final CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('pets');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    allPetsData = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data()
      as Map<String, dynamic>;

      return PetInfo(
          petId: doc.id,
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
      allPets = AllPets(pets: allPetsData); 
      if (allPets.pets.isNotEmpty) {
        pet = allPets.pets[0];
      }
    });
  }


  void openFilterDialog(BuildContext context) {
    String typeFilter = '';
    String breedFilter = '';

    List<String> types = ["Dog", "Cat", "Other"];
    List<String> breeds = ["Pug", "Golden Retriever", "Bengal", "Persian", "Other"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter pets'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<String>(
                    value: typeFilter.isNotEmpty ? typeFilter : null,
                    hint: const Text("Select a type"),
                    items: types.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        typeFilter = value ?? '';
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: breedFilter.isNotEmpty ? breedFilter : null,
                    hint: const Text("Select a breed"),
                    items: breeds.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        breedFilter = value ?? '';
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Clear filters'),
                  onPressed: () {
                    setState(() {
                      typeFilter = '';
                      breedFilter = '';
                    });
                    Navigator.pop(context);
                    this.setState(() {
                      allPets = AllPets(pets: allPetsData);
                    });
                  },
                ),
                TextButton(
                  child: const Text('Apply filters'),
                  onPressed: () {
                    Navigator.pop(context);
                    this.setState(() {
                      allPets = AllPets(pets: allPetsData.where((petInfo) {
                        if (typeFilter.isNotEmpty && breedFilter.isNotEmpty) {
                          return petInfo.type == typeFilter && petInfo.breed == breedFilter;
                        } else if (typeFilter.isNotEmpty) {
                          return petInfo.type == typeFilter;
                        } else if (breedFilter.isNotEmpty) {
                          return petInfo.breed == breedFilter;
                        }
                        return true;
                      }).toList());
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPet(BuildContext context, PetInfo pet) {
    if (typeFilter != null && pet.type != typeFilter) {
      return Container();
    }
    if (breedFilter != null && pet.breed != breedFilter) {
      return Container();
    }

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
        title: Text('${pet.name}',
            style: Theme.of(context).textTheme.headlineLarge),
        subtitle: Row(
          children: [
            Text('${pet.type} - ${pet.breed}',
                style: Theme.of(context).textTheme.bodyMedium)
          ],
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
  @override
  Widget build(BuildContext context) {
    var filteredPets = allPets.pets.where((pet) {
      if (typeFilter != null && pet.type != typeFilter) {
        return false;
      }
      if (breedFilter != null && pet.breed != breedFilter) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Woof-Me'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => openFilterDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getData,
        child: ListView.builder(
          itemCount: filteredPets.length,
          itemBuilder: (context, index) =>
              _buildPet(context, filteredPets[index]),
        ),
      ),
    );
  }

}

