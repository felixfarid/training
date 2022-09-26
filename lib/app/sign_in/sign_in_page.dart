import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import '../../services/auth.dart';
import './sign_in_button.dart';
import 'social_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.bloc});
  final SignInBloc bloc;

  // why static -> SignInBloc is useful when we use it together
  // with the SignInPage.
  // Use a static create(context)
  //
  // Since SignInBloc is parent of SignInPage - we can access
  // bloc from SignInPage.
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false); // [239]
    return Provider<SignInBloc>(
      // use "_" for arguments that are not needed
      create: (_) => SignInBloc(auth: auth),
      // use consumer here from Provider package.
      // Consumer(builder: (context, value, child))
      // [236]
      child: Consumer<SignInBloc>(
        builder: ((_, bloc, __) => SignInPage(bloc: bloc)),
      ),
      // [237] - dispose the bloc when it's removed from widget tree
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  // [235] - removed local _isLoading.
  // now it comes from  Bloc snapshot.data
  //// bool _isLoading = false;

  //----------------------------------------------------------------------------
  // Sign In methods
  //----------------------------------------------------------------------------

  // [162]
  Future<void> _signInWithGoogle(BuildContext context) async {
    // [235]
    try {
      // [239] - we can delete _setIsLoading since
      // bloc handles it internally now
      // as well no need to have auth instance here anymore.
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  // [181]
  void _signInWithEmail(BuildContext context) {
    // [182]
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const EmailSignInPage(), //[189]
      ),
    );
  }

  // we will use Dependency injection - we will inject Auth class
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      // it returns Future type - UserCredential
      // since this method returns future - use await
      // [239]
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
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

  // [235] - _showLoading - depreceated
  // using bloc in sign in methods
  //// void _showLoading() {
  //   // setState(() => _isLoading = !_isLoading);
  //// }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
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
  // [233] - adding new bool argument. Extracted from snapshot.data
  Widget _buildContent(
    BuildContext context,
    bool? isLoading,
  ) {
    return Padding(
      // color: Colors.amber,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          _buildHeader(isLoading!),
          const SizedBox(height: 30),
          SocialSignInButton(
            text: 'Google',
            asset: 'images/google-logo.png',
            color: Colors.white,
            textColor: Colors.black87,
            borderRadius: 16,
            onPressed:
                !isLoading! ? () => _signInWithGoogle(context) : null, //[162]
          ),
          const SizedBox(height: 10),
          SignInButton(
            text: 'Email',
            color: const Color.fromARGB(255, 50, 121, 52),
            onPressed: !isLoading ? () => _signInWithEmail(context) : null,
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
            onPressed: !isLoading ? () => _signInAnonymously(context) : null,
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
    // [234]
    // no need to wrap entire Scaffold with StreamBuilder
    // as AppBar does not change
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        elevation: 2,
      ),
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          // since we are providing initial data (false)
          // no need to check for initial connectionState
          //
          // additionally, SignInBloC does not add any errors to the stream
          // no need to check for them.
          initialData: false,
          builder: (context, snapshot) {
            // [233]
            // extract loadingState from snapshot
            // add new bool paremeter to _buildContent
            return _buildContent(
              context,
              snapshot.data,
            );
          }),
      backgroundColor: Colors.grey[100],
    );
  }
}
