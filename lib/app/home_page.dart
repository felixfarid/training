import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';

import '../services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  //// final VoidCallback onSignOut;

  Future<void> _signOut(BuildContext context) async {
    try {
      // final auth = AuthProvider.of(context); //[215]
      final auth = Provider.of<AuthBase>(context, listen: false); //[217]
      //// await FirebaseAuth.instance.signOut();
      await auth.signOut(); // new
      //// onSignOut(); no need
    } catch (e) {
      print(e.toString());
      print('Could not sign out');
    }
  }

  // [210] - sign out dialog
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActionText: 'Yes',
      cancelActionText: 'No',
    );
    if (didRequestSignOut == true) {
      // ignore: use_build_context_synchronously
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          TextButton(
            // onPressed: _signOut,
            onPressed: () => _confirmSignOut(context), //210
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
