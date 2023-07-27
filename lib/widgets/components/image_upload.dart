import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

Future<void> editProfilePicture(BuildContext context) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');

  String imageURL = '';

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Enter Image URL'),
      content: TextField(
        onChanged: (value) => imageURL = value,
        decoration: const InputDecoration(
          hintText: 'Image URL',
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Upload'),
          onPressed: () async {
            Navigator.of(context).pop();

            if (imageURL.trim().isNotEmpty) {
              var response = await http.get(Uri.parse(imageURL));

              final reference = FirebaseStorage.instance.ref('user_pics/${currentUser.email}');
              final uploadTask = reference.putData(response.bodyBytes);
              final taskSnapshot = await uploadTask.whenComplete(() {});
              final downloadURL = await taskSnapshot.ref.getDownloadURL();

              await userCollection.doc(currentUser.email).update({
                'pic': downloadURL,
              });
            }
          },
        ),
      ],
    ),
  );
}

