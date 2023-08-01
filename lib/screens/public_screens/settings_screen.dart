import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/public_navigation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  final user = FirebaseAuth.instance.currentUser!;

 Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(user.email).get();

    if (doc.exists && doc.get('is_admin') != null) {
      return doc.get('is_admin') as bool;
    }
    return false;
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
          bool isAdmin = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Signed in as'),
                Text(
                  '${user.email}',
                  style: optionStyle,
                ),
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
                const SizedBox(height: 20.0),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50.0)),
                  icon: const Icon(Icons.exit_to_app_rounded, size: 30),
                  label: const Text('Sign Out'),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                )
              ]),
          );
        } else {
          return const Text('Something went wrong'); // In case of any other unexpected situation
        }
      },
    );
  }
}