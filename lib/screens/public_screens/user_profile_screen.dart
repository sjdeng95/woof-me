import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woofme/widgets/components/text_box.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  // all users
  final userCollection = FirebaseFirestore.instance.collection('Users');

  // edit field
  Future<void> editField(String field) async {
    String newValue = "";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter new $field",
            contentPadding: const EdgeInsets.symmetric(vertical: 40.0),

          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel button
          TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context)),

          // save button
          TextButton(
            child: const Text('Save'),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );
    // update in firestore
    if (newValue.trim().isNotEmpty){
      await userCollection.doc(currentUser.email).update({field:newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            // get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(height: 50),

                  // profile picture
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),

                  const SizedBox(height: 10),

                  // user email
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  //user details
                  const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text("User Details"),
                  ),

                  TextBox(
                    text: userData['username'],
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),

                  TextBox(
                    text: userData['phone'],
                    sectionName: 'Phone Number',
                    onPressed: () => editField('phone'),
                  ),

                  TextBox(
                    text: userData['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}
