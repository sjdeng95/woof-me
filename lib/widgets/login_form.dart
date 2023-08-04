import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woofme/screens/signin_screens/forgot_password_screen.dart';
import 'package:woofme/widgets/components/utils.dart';

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
    return Stack(children: <Widget>[
      Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/pup1.jpg'),
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
                      height: 35,
                    ),
                    Text(
                      "Welcome Back,",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Lets find your Paw-fect Match!",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const Icon(
                      Icons.pets,
                      size: 30,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your email'
                          : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.25),
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(),
                          labelText: "Password"),
                      style: Theme.of(context).textTheme.bodyMedium,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your email'
                          : null,
                    ),
                    const SizedBox(height: 15.0),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50.0),
                      ),
                      icon: const Icon(Icons.lock_open, size: 30),
                      label: Text('Sign In',
                          style: Theme.of(context).textTheme.displayMedium),
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
                        Text('No Account? ',
                            style: Theme.of(context).textTheme.bodyMedium),
                        GestureDetector(
                            onTap: widget.onTapSignUp,
                            child: Text('Sign Up',
                                style:
                                    Theme.of(context).textTheme.labelMedium)),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                        child: Text('Forget Password?',
                            style: Theme.of(context).textTheme.labelMedium),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()))),
                  ]))),
    ]);
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      Utils.showSnackBar(e.message);
    }
  }
}

// extra ui decoration removed
// const SizedBox(height: 40.0),
// Image.asset(
//   'assets/images/login_dog.gif',
//   width: 200,
//   height: 200,
//   fit: BoxFit.contain,
// )