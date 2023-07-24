import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woofme/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences preference;
  const MyApp({Key? key, required this.preference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
