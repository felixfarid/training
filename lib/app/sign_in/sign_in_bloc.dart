import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth.dart';

// [232]
class SignInBloc {
  // [238] - moving authentication to bloc
  SignInBloc({required this.auth});
  final AuthBase auth;

  // _isLoadingController is private variable
  // this is intentional as the sign in page will have access
  // to isLoadingStream but not to the controller
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  // this will be input stream that we will add to our page
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  // this is the same as adding sink to the controller
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  // [238] - move authentication logic in here
  // create a method which will take a function as an argument
  //
  // we are passing Function() which returns future as an argument
  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  // [238]
  // the following methods will be called in sign_in_page.dart
  Future<User?> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User?> signInWithGoogle() async =>
      await _signIn(auth.signInWithGoogle);
}
