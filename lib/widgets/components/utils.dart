import 'package:flutter/material.dart';

class Utils {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? message) {
    if (message == null) return;

    // final snackBar =
    SnackBar(content: Text(message), backgroundColor: Colors.red);

    // messengerKey.currentState!
    // ..removeCurrentSnackBar()
    // ..showSnackBar(snackBar);
  }
}
