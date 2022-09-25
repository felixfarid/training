import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import '../../services/auth.dart';
import './sign_in_button.dart';
import 'social_sign_in_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //// final void Function(User) onSignIn;
  //// final AuthBase auth;

  // [228]
  bool _isLoading = false;

  //----------------------------------------------------------------------------
  // Sign In methods
  //----------------------------------------------------------------------------

  // [162]
  Future<void> _signInWithGoogle(BuildContext context) async {
    _showLoading();
    try {
      //// final auth = AuthProvider.of(context); //[215]
      final auth = Provider.of<AuthBase>(context, listen: false); //[217]
      await auth.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
      // [223]
      _showLoading();
    }
  }

  // [181]
  void _signInWithEmail(BuildContext context) {
    // _showLoading();
    //// final auth = AuthProvider.of(context); //[215]
    // [182]
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const EmailSignInPage(), //[189]
      ),
    );
    // _showLoading();
  }

  // we will use Dependency injection - we will inject Auth class
  Future<void> _signInAnonymously(BuildContext context) async {
    _showLoading();
    try {
      //// final auth = AuthProvider.of(context); //[215]
      final auth = Provider.of<AuthBase>(context, listen: false); //[217]
      // it returns Future type - UserCredential
      // since this method returns future - use await
      //// final userCredentials = await FirebaseAuth.instance.signInAnonymously();
      //// final user = await auth.signInAnonymously(); // no need assign it
      await auth.signInAnonymously();

      //// onSignIn(userCredentials.user!);
      //// onSignIn(user!); // no need for this anymore
    } on Exception catch (e) {
      _showSignInError(context, e);
      // [223]
      _showLoading();
    }
  }

  //----------------------------------------------------------------------------
  // Error handling
  //----------------------------------------------------------------------------
  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        (exception.code == 'ERROR_ABORTED_BY_USER' ||
            exception.code == 'ERROR_MISSING_GOOGLE_ID_TOKEN')) {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  //----------------------------------------------------------------------------
  // Loading
  //----------------------------------------------------------------------------

  void _showLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  Widget _buildHeader() {
    if (_isLoading) {
      return const SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return const SizedBox(
      height: 50,
      child: Text(
        'Sign in',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // Contents
  //----------------------------------------------------------------------------
  Widget _buildContent(BuildContext context) {
    return Padding(
      // color: Colors.amber,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          _buildHeader(),
          const SizedBox(height: 30),
          SocialSignInButton(
            text: 'Google',
            asset: 'images/google-logo.png',
            color: Colors.white,
            textColor: Colors.black87,
            borderRadius: 16,
            onPressed:
                !_isLoading ? () => _signInWithGoogle(context) : null, //[162]
          ),
          const SizedBox(height: 10),
          SignInButton(
            text: 'Email',
            color: const Color.fromARGB(255, 50, 121, 52),
            onPressed: !_isLoading ? () => _signInWithEmail(context) : null,
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
            onPressed: !_isLoading ? () => _signInAnonymously(context) : null,
            borderRadius: 16,
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  // BUILD
  //----------------------------------------------------------------------------
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
}
