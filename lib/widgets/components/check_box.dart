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

  bool like_good_w_animals = false;
  bool like_good_w_children = false;
  bool like_must_leash = false;
  
  @override
  void initState() {
    super.initState();
    getUserPreferences().then((userData) {
      setState(() {
        like_good_w_animals = userData['like_good_w_animals'];
        like_good_w_children = userData['like_good_w_children'];
        like_must_leash = userData['like_must_leash'];
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
          left: 15,),
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            value: like_good_w_animals,
            onChanged: (bool? value) {
              setState(() {
                like_good_w_animals = value!;
              });
              updateField('like_good_w_animals', like_good_w_animals);
            },
            title: const Text('Good With Other Animals'),
          ),
          const Divider(height: 0),
          CheckboxListTile(
            value: like_good_w_children,
            onChanged: (bool? value) {
              setState(() {
                like_good_w_children = value!;
              });
              updateField('like_good_w_children', like_good_w_children);
            },
            title: const Text('Good With Children'),
          ),
          const Divider(height: 0),
          CheckboxListTile(
            value: like_must_leash,
            onChanged: (bool? value) {
              setState(() {
                like_must_leash = value!;
              });
              updateField('like_must_leash', like_must_leash);
            },
            title: const Text('Pets Leashed At All Times'),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
