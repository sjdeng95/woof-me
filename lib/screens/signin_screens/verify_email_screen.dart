import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:woofme/widgets/admin_navigation.dart';
import 'package:woofme/widgets/components/utils.dart';
import 'package:woofme/widgets/public_navigation.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get();

    if (doc.exists && doc.get('is_admin') != null) {
      return doc.get('is_admin') as bool;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data == true) {
          return const AdminNavigation();
        } else if (snapshot.hasData && snapshot.data == false) {
          return isEmailVerified
              ? const PublicNavigation()
              : Scaffold(
                  appBar: AppBar(
                    title: const Text('Verify Email'),
                  ),
                  body: Stack(children: <Widget>[
                    Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                opacity: 30,
                                image: AssetImage('assets/images/pup3.jpg'),
                                fit: BoxFit.fitHeight))),
                    Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50),
                              Text(
                                  'Please verify your email. An email was sent to ${FirebaseAuth.instance.currentUser!.email}.',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 30),
                              FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50.0),
                                ),
                                icon: const Icon(Icons.email_rounded, size: 30),
                                label: Text('Resend Email',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium),
                                onPressed: () => canResendEmail
                                    ? sendVerificationEmail()
                                    : null,
                              ),
                              const SizedBox(height: 30),
                              FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50.0),
                                ),
                                child: Text('Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                onPressed: () =>
                                    FirebaseAuth.instance.signOut(),
                              ),
                            ]))
                  ]));
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }
}
