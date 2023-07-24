import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:woofme/widgets/login_form.dart';
import 'package:woofme/widgets/public_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const PublicNavigation();
            } else {
              return const LoginForm();
            }
          }),
    );
  }
}
