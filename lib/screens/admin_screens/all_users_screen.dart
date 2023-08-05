import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woofme/models/all_users.dart';
import 'package:woofme/models/user_info.dart';

import 'package:woofme/screens/public_screens/user_profile_screen.dart';

import '../../utils/misc_functions.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  AllUsers allUsers = AllUsers();

  UserInfo user = UserInfo();

  @override
  void initState() {
    super.initState();
    getData();
  }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Users');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final userInfo = querySnapshot.docs.map((doc) {
      return UserInfo(
          name: doc['name'],
          likedType: capitalize(doc['like_type']),
          likedBreed: capitalize(doc['like_breed']),
          email: doc['email'],
          bio: doc['bio'],
          pic: doc['pic']);
    }).toList();
    setState(() {
      allUsers = AllUsers(users: userInfo);
      user = allUsers.users[0];
    });
  }

  Widget _buildUser(BuildContext context, UserInfo user) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          height: double.infinity,
          child: CircleAvatar(
            backgroundImage: user.pic != null && user.pic!.isNotEmpty
                ? NetworkImage('${user.pic}')
                : null,
            child: user.pic == null || user.pic!.isEmpty
                ? const Icon(Icons.person) // Show default user icon if user picture is not available
                : null,
          ),
        ),
        title: Text('${user.name}',
            style: Theme.of(context).textTheme.headlineMedium),
        subtitle: Row(
          children: [
            Text('Saved Pets: ${user.likedPetsCount}'),
          ],
        ),
        trailing: SizedBox(height: double.infinity, child: Text(user.email!)),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) =>
                      UserProfileScreen(email: user.email))));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Users'),
        ),
        body: ListView.builder(
          itemCount: allUsers.numberOfUsers,
          itemBuilder: (context, index) =>
              _buildUser(context, allUsers.users[index]),
        ));
  }
}
