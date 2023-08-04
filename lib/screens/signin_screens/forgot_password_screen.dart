import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:woofme/widgets/components/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Enter your email to reset your password:',
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Please enter a valid email'
                                : null,
                      ),
                      const SizedBox(height: 15.0),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50.0),
                        ),
                        icon: const Icon(Icons.email_rounded, size: 30),
                        label: Text('Reset Password',
                            style: Theme.of(context).textTheme.displayMedium),
                        onPressed: () {
                          resetPassword();
                        },
                      ),
                    ]))));
  }

  Future resetPassword() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Password Reset Email Sent');
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);

      Utils.showSnackBar(e.message);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
