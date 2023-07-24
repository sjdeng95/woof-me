// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woofme/widgets/login_form.dart';
import 'package:woofme/widgets/signup_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginForm(
          onTapSignUp: toggle,
        )
      : SignUpForm(onTapSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
