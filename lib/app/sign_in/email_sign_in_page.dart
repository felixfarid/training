import 'package:flutter/material.dart';
// import 'package:time_tracker/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'email_sign_in_form_change_notifier.dart';
// import 'email_sign_in_form_stateful.dart';

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
            // [263]
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
