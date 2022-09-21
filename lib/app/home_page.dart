import 'package:flutter/material.dart';

import '../services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.auth});

  //// final VoidCallback onSignOut;
  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      //// await FirebaseAuth.instance.signOut();
      await auth.signOut(); // new
      //// onSignOut(); no need
    } catch (e) {
      print(e.toString());
      print('Could not sign out');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          TextButton(
            onPressed: _signOut,
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
