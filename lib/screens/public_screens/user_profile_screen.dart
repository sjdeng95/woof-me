import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woofme/widgets/components/text_box.dart';
import 'package:woofme/widgets/components/check_box.dart';
import '../../utils/image_upload.dart';

class UserProfileScreen extends StatefulWidget {
  final String? email;

  const UserProfileScreen({super.key, this.email});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  // all users
  final userCollection = FirebaseFirestore.instance.collection('Users');

  String get email => widget.email ?? currentUser.email!;

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
    if (newValue.trim().isNotEmpty) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(email)
              .snapshots(),
          builder: (context, snapshot) {
            // get user data
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(height: 50),

                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () => editProfilePicture(context),
                      child:
                          userData['pic'] != null && userData['pic'].isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    userData['pic'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.person, size: 72),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // username
                  Text(
                    userData['username'],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  // user email
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SwitchListTile(
                      // This bool value toggles the switch.
                      title: Text('Admin Account',
                          style: Theme.of(context).textTheme.headlineSmall),
                      value: userData['is_admin'],
                      activeColor: Colors.red,
                      onChanged: (value) => userCollection
                          .doc(userData['email'])
                          .update({'is_admin': value}),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //user details
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text("User Details",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),

                  TextBox(
                    text: userData['name'],
                    sectionName: 'Name',
                    onPressed: () => editField('name'),
                  ),
                  TextBox(
                    text: userData['username'],
                    sectionName: 'Username',
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
                  TextBox(
                    text: userData['like_type'],
                    sectionName: 'Favorite Species',
                    onPressed: () => editField('like_type'),
                  ),
                  TextBox(
                    text: userData['like_breed'],
                    sectionName: 'Favorite Breed',
                    onPressed: () => editField('like_breed'),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text("Pet Preferences",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),

                  const PreferencesCheckBox(),

                  const SizedBox(
                    height: 50,
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
