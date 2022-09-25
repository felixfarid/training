import 'package:flutter/material.dart';
import 'email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  // [189] - this class doesn't have Auth class yet
  // we need to pass it in here as well
  // actually it's not convinient to pass
  // dependencies, since this class doesn't need Auth class
  const EmailSignInPage({super.key});

  //// final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        // [202] scroll the scaffold
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: EmailSignInForm(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
