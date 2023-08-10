import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
Future<void> editProfilePicture(BuildContext context) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  
  final imageFile = await pickImage();
  if (imageFile == null) {
    return;
  }

  final reference = FirebaseStorage.instance.ref('user_pics/${currentUser.email}');
  final uploadTask = reference.putFile(imageFile);
  final taskSnapshot = await uploadTask.whenComplete(() {});
  final downloadURL = await taskSnapshot.ref.getDownloadURL();

  await userCollection.doc(currentUser.email).update({
    'pic': downloadURL,
  });
}

void showErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text('No image selected. Please try again.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
