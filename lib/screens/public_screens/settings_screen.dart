import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//     import '../../widgets/public_navigation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController emailController = TextEditingController();

  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get();

    if (doc.exists && doc.get('is_admin') != null) {
      return doc.get('is_admin') as bool;
    }
    return false;
  }

  void makeUserAdmin(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Make User Admin"),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: "Enter User Email"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String email = emailController.text;
                DocumentSnapshot doc = await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(email)
                    .get();

                if (doc.exists) {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(email)
                      .update({'is_admin': true});
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("User does not exist"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Signed in as',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10.0),
                  Text('${user.email}',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20.0),
                  if (snapshot.data!) // only for admins
                    ElevatedButton(
                      onPressed: () => makeUserAdmin(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Make User Admin'),
                    ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    icon: const Icon(Icons.exit_to_app_rounded, size: 30),
                    label: Text('Sign Out',
                        style: Theme.of(context).textTheme.displayMedium),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text('Something went wrong',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium); // In case of any other unexpected situation
        }
      },
    );
  }
}




// if (isAdmin)  // Render the SwitchListTile only if the user is admin
//   SwitchListTile(
//     title: const Text("Switch to Public Navigation"),
//     value: false,
//     onChanged: (value) {
//       if (value) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const PublicNavigation()),
//         );
//       }
//     },
//   ),
