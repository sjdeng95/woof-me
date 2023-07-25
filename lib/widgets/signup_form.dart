import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  final VoidCallback onTapSignIn;

  const SignUpForm({
    Key? key,
    required this.onTapSignIn,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const TextStyle linkStyle = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.blueAccent);

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50.0),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 30),
                    label: const Text('Sign Up', style: optionStyle),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please sign up with an email and password')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?  '),
                      GestureDetector(
                        onTap: widget.onTapSignIn,
                        child: const Text('Sign In', style: linkStyle),
                      ),
                    ],
                  ),
                ])));
  }

  Future signUp() async {
    try {

      // Creating the user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // creating a new document in cloud firebase
      FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.email)
        .set({
          'username': emailController.text.split('@')[0],
          'bio': 'empty bio'
        });
    } on FirebaseAuthException catch (e) {
      log(e as String);
    }
  }
}
