import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:woofme/screens/admin_screens/all_users_screen.dart';
import 'package:woofme/screens/admin_screens/new_pet_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;

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
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text('Signed in as',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    '${user.email}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  if (isAdmin) adminSettings(context),
                  const SizedBox(height: 40.0),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
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

  Widget adminSettings(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 191, 210, 223),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Admin Settings',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            ElevatedButton.icon(
                icon: const Icon(Icons.my_library_add_outlined, size: 30),
                label: Text('Add Pet',
                    style: Theme.of(context).textTheme.headlineSmall),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewPetScreen(),
                    ))),
            ElevatedButton.icon(
                icon: const Icon(Icons.group, size: 30),
                label: Text('View Users',
                    style: Theme.of(context).textTheme.headlineSmall),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AllUsersScreen(fromAdmin: true),
                    ))),
          ],
        ),
      ),
    );
  }
}
