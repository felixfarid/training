import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_page.dart';
import '../../services/auth.dart';
import './sign_in_button.dart';
import 'social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    super.key,
    required this.auth,
  });
  //// final void Function(User) onSignIn;
  final AuthBase auth;

  // we will use Dependency injection - we will inject Auth class
  Future<void> _signInAnonymously() async {
    try {
      // it returns Future type - UserCredential
      // since this method returns future - use await
      //// final userCredentials = await FirebaseAuth.instance.signInAnonymously();
      //// final user = await auth.signInAnonymously(); // no need assign it
      await auth.signInAnonymously();

      //// onSignIn(userCredentials.user!);
      //// onSignIn(user!); // no need for this anymore
    } catch (e) {
      print(e.toString());
    }
  }

  // [162]
  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  // [181]
  void _signInWithEmail(BuildContext context) {
    // [182]
    //
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        elevation: 2,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[100],
    );
  }

  // safe to do widget
  // private - accessible only at file level
  // it's good because it's will internally used
  // when another dev looks at your code, they will
  // understand that which variable is public
  // which is ment to private
  Widget _buildContent(BuildContext context) {
    return Padding(
      // color: Colors.amber,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 50),
          SocialSignInButton(
            text: 'Google',
            asset: 'images/google-logo.png',
            color: Colors.white,
            textColor: Colors.black87,
            borderRadius: 16,
            onPressed: _signInWithGoogle, //[162]
          ),
          const SizedBox(height: 10),
          SocialSignInButton(
            text: 'Facebook',
            asset: 'images/facebook-logo.png',
            color: const Color(0xFF334D92),
            borderRadius: 16,
            onPressed: () {},
          ),
          const SizedBox(height: 10),
          SignInButton(
            text: 'Email',
            color: const Color.fromARGB(255, 50, 121, 52),
            onPressed: () => _signInWithEmail(context),
            borderRadius: 16,
          ),
          const SizedBox(height: 10),
          const Text(
            'Or',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          SignInButton(
            text: 'Go Anonymous',
            color: Colors.lime,
            textColor: Colors.black87,
            // we could use () => _signInAnonymousle()
            // if with () it's method invocation.
            // because this is a callback that takes no arg.
            // and signInA. takes no arguments, we can pass as it is
            onPressed: _signInAnonymously,
            borderRadius: 16,
          ),
        ],
      ),
    );
  }
}
