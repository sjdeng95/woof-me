import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:woofme/models/pet_info.dart';
import 'package:woofme/screens/admin_screens/all_pets_screen.dart';
import 'package:woofme/widgets/pet_info_basic.dart';
import 'package:woofme/widgets/pet_info_more.dart';
import '../admin_screens/edit_pet_screen.dart';

class PetProfileScreen extends StatefulWidget {
  final PetInfo petInfo;
  const PetProfileScreen({Key? key, required this.petInfo}) : super(key: key);

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState(petInfo);
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  PetInfo petInfo;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference _usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  bool isAdmin = false;
  _PetProfileScreenState(this.petInfo);

  @override
  void initState() {
    super.initState();
    getAdminStatus();
  }

  Future<void> getAdminStatus() async {
    DocumentSnapshot userDoc = await _usersCollectionRef.doc(currentUser.email).get();
    setState(() {
      isAdmin = userDoc['is_admin'];
    });
  }

  void deletePet() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${widget.petInfo.name}?'),
          content: Text('Are you sure you want to delete ${widget.petInfo.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance.collection('pets').doc(widget.petInfo.petId).delete();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AllPetsScreen()),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        if (kDebugMode) {
          print("Error deleting pet: $e");
        }
      }
    }
  }

  Future<void> editPet() async {
    final updatedPetInfo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPetScreen(petInfo: petInfo)),
    ) as PetInfo?;

    if (updatedPetInfo != null) {
      setState(() {
        petInfo = updatedPetInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All About ${petInfo.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: ListView(children: [
          PetInfoBasic(petInfo: petInfo),
          PetInfoMore(petInfo: petInfo),
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: deletePet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      fixedSize: const Size(140, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: editPet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      fixedSize: const Size(140, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ]),
      ),
    );
  }
}
