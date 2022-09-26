import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';
import 'home_page.dart';
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
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // return const SignInPage();
            return SignInPage.create(context); // [233]
          }
          return const HomePage();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }

  //// @override
  //// State<LandingPage> createState() => _LandingPageState();
//// }

//// class _LandingPageState extends State<LandingPage> {
  // THE FOLLOWING CODE WAS REPLACED BY STREAMBUILDER
  // [156]

  //// User? _user; // no need to use anymore [156]

  //// to update the _user when application starts

  //// @override
  //// void initState() {
  ////     super.initState();

  //// FirebaseAuth.instance.currentUser;
  //// _updateUser(FirebaseAuth.instance.currentUser);

  ////   // Listen to the stream [153]
  ////   widget.auth.authStateChanges().listen((user) {
  ////     print('uid: ${user?.uid}');
  ////   });

  ////   // to access auth in statefull widget - type widget.auth
  ////   _updateUser(widget.auth.currentUser);
  ////  }

  //// void _updateUser(User? user) {
  ////   // print('User id: ${user!.uid}');
  ////   setState(() {
  ////     _user = user;
  ////   });
  //// }

  // removing code below
  // will use StreamBuilder instead
  //// if (_user == null) {
  ////   return SignInPage(
  ////     // onSignIn: (user) => _updateUser(user),
  ////     onSignIn: _updateUser,
  ////     auth: widget.auth,
  ////   );
  //// }
  //// return HomePage(
  ////   onSignOut: () => _updateUser(null),
  ////   auth: widget.auth,
  //// );
}
