import 'package:flutter/material.dart';
import 'package:woofme/screens/signin_screens/login_screen.dart';
import 'package:woofme/widgets/components/utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black87,
              ),
              titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          textTheme: const TextTheme(
              headlineLarge:
                  TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              headlineMedium:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              headlineSmall:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              labelMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              displayMedium: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              bodyLarge: TextStyle(fontSize: 20),
              bodyMedium: TextStyle(fontSize: 16),
              bodySmall: TextStyle(fontSize: 14))),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
