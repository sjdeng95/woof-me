import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencesCheckBox extends StatefulWidget {
  const PreferencesCheckBox({super.key});

  @override
  State<PreferencesCheckBox> createState() => _PreferencesCheckBoxState();
}

class _PreferencesCheckBoxState extends State<PreferencesCheckBox> {
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool goodWithAnimals = false;
  bool goodWithChildren = false;
  bool likeLeash = false;

  @override
  void initState() {
    super.initState();
    getUserPreferences().then((userData) {
      setState(() {
        goodWithAnimals = userData['like_good_w_animals'];
        goodWithChildren = userData['like_good_w_children'];
        likeLeash = userData['like_must_leash'];
      });
    });
  }

  Future<DocumentSnapshot> getUserPreferences() async {
    return await userCollection.doc(currentUser.email).get();
  }

  Future<void> updateField(String field, bool value) {
    return userCollection.doc(currentUser.email).update({field: value});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        bottom: 15,
        left: 15,
      ),
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            value: goodWithAnimals,
            activeColor: Colors.green,
            onChanged: (bool? value) {
              setState(() {
                goodWithAnimals = value!;
              });
              updateField('like_good_w_animals', goodWithAnimals);
            },
            title: const Text('Good With Other Animals'),
          ),
          const Divider(height: 0),
          CheckboxListTile(
            value: goodWithChildren,
            activeColor: Colors.green,
            onChanged: (bool? value) {
              setState(() {
                goodWithChildren = value!;
              });
              updateField('like_good_w_children', goodWithChildren);
            },
            title: const Text('Good With Children'),
          ),
          const Divider(height: 0),
          CheckboxListTile(
            value: likeLeash,
            activeColor: Colors.green,
            onChanged: (bool? value) {
              setState(() {
                likeLeash = value!;
              });
              updateField('like_must_leash', likeLeash);
            },
            title: const Text('Pets Leashed At All Times'),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
