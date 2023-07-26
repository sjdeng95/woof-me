import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onTapSignUp;

  const LoginForm({
    Key? key,
    required this.onTapSignUp,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  // TODO: update ICON later
                  const Icon(
                    Icons.pets,
                    size: 70,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Welcome Back, Lets find your Paw-fect Match!",
                  ),
                  const SizedBox(
                    height: 20,
                  ),

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
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50.0),
                    ),
                    icon: const Icon(Icons.lock_open, size: 30),
                    label: const Text('Sign In', style: optionStyle),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signIn();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please fill in your email and password')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No Account? '),
                      GestureDetector(
                          onTap: widget.onTapSignUp,
                          child: const Text('Sign Up', style: linkStyle)),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                      child: const Text('Forget Username?', style: linkStyle),
                      onTap: () {}),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                      child: const Text('Forget Password?', style: linkStyle),
                      onTap: () {}),
                ])));
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      log(e as String);
    }
  }
}
