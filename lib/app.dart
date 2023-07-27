import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woofme/screens/login_screen.dart';
import 'package:woofme/widgets/components/utils.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences preference;
  const MyApp({Key? key, required this.preference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
