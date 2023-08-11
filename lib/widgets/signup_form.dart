import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woofme/screens/signin_screens/update_user_info.dart';
import 'package:woofme/widgets/components/utils.dart';

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
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: 30,
                  image: AssetImage('assets/images/pup2.jpg'),
                  fit: BoxFit.fitHeight))),
      Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      'assets/images/puppaw.png',
                      width: 50,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "I woof you already!",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: fullNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.25),
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(),
                          labelText: "Full Name"),
                      style: Theme.of(context).textTheme.bodyMedium,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (name) =>
                          name == null ? 'Please enter your full name' : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.25),
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(),
                          labelText: "Email"),
                      style: Theme.of(context).textTheme.bodyMedium,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Please enter a valid email'
                              : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.25),
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(),
                          labelText: "Password"),
                      style: Theme.of(context).textTheme.bodyMedium,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 8
                          ? 'Please enter a password of atleast 8 characters.'
                          : null,
                    ),
                    const SizedBox(height: 15.0),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50.0),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 30),
                      label: Text('Sign Up',
                          style: Theme.of(context).textTheme.displayMedium),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signUp();
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?  ',
                            style: Theme.of(context).textTheme.bodyMedium),
                        GestureDetector(
                          onTap: widget.onTapSignIn,
                          child: Text('Sign In',
                              style: Theme.of(context).textTheme.labelMedium),
                        ),
                      ],
                    ),
                  ]))),
    ]);
  }

  Future signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': emailController.text.split('@')[0],
        'email': emailController.text,
        'bio': '',
        'is_admin': false,
        'like_breed': '',
        'like_good_w_animals': false,
        'like_good_w_children': false,
        'like_must_leash': false,
        'like_type': '',
        'liked_pets': [],
        'disliked_pets': [],
        'name': fullNameController.text,
        'phone': '',
        'pic': '',
      });
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UpdateUserInfoScreen(userDocId: userCredential.user!.email!)),
        );
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      Utils.showSnackBar(e.message);
    }
  }
}
