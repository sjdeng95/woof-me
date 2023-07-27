import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woofme/screens/public_screens/home_screen.dart';
import 'package:woofme/widgets/components/check_box.dart';

class UpdateUserInfoScreen extends StatefulWidget {
   const UpdateUserInfoScreen({Key? key, required String userDocId, }) : super(key: key);

  @override
  UpdateUserInfoScreenState createState() => UpdateUserInfoScreenState();
}

class UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final likeTypeController = TextEditingController();
  final likeBreedController =TextEditingController(); 

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    nameController.dispose();
    phoneController.dispose();
    likeTypeController.dispose();
    likeBreedController.dispose;
    super.dispose();
  }

  Future<DocumentSnapshot> getUserDoc() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: getUserDoc(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

        // Update the controllers with the data from Firestore
        usernameController.text = data['username'];
        bioController.text = data['bio'];
        nameController.text = data['name'];
        phoneController.text = data['phone'];
        likeTypeController.text = data['like_type'];
        likeBreedController.text = data['like_breed'];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Update User Information'),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Username"),
                  ),
                  const SizedBox(height: 5,),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Name"),
                  ),
                  const SizedBox(height: 5,),
                 
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Phone"),
                  ),
                  const SizedBox(height: 5,),

                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    controller: bioController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Bio"),
                  ),
                  const SizedBox(height: 5,),
                  
                  TextFormField(
                    controller: likeTypeController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Favorite Species"),
                  ),
                  const SizedBox(height: 5,),
                  
                  TextFormField(
                    controller: likeBreedController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Favorite Breed"),
                  ),
                  const SizedBox(height: 20,),
                  const Text('Pet Preferences'),
                  const PreferencesCheckBox(),

                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateUserDoc();
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),);                      
                          }
                    }
                  )
                ],
              ),),
            ),
          ),
        );
      },
    );
  }

  Future updateUserDoc() async {
    try {
      await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
          'username': usernameController.text,
          'bio': bioController.text,
          'name': nameController.text,
          'phone': phoneController.text,
          'like_type':likeTypeController.text,
          'like_breed': likeBreedController.text,
        });
    } catch (e) {
      log(e.toString());
    }
  }
}
