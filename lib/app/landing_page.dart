import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';
import '../services/database.dart';
import 'home/jobs_page.dart';
import 'sign_in/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  // [215]
  const LandingPage({super.key});
  // there is not an immutable state anymore in this page
  // we can change to StateLess widget.

  @override
  Widget build(BuildContext context) {
    // StreamBuilder - easy way to work with streams [154]
    // [215]
    final auth = Provider.of<AuthBase>(context, listen: false); //[217]
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      // SNAPSHOT - holds the data from our stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // return const SignInPage();
            return SignInPage.create(context); // [233]
          }
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
            child: JobsPage(),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
