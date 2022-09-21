import 'package:firebase_auth/firebase_auth.dart';

// by using this lcass we hid away all the implementation details
// of firebase auth.
//
// and as well if we want to use another auth approach
// we can easily change it.

// let's create public interface
// no need to implement variables since it's an abstract class
abstract class AuthBase {
  User? get currentUser;
  Future<User?> signInAnonymously();
  Future<void> signOut();
  Stream<User?> authStateChanges();
}

// if using - implements
// you need to @override methods
class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  // Stream for State Management
  // authStateChanges - notifies about changes to the user's sign-in state
  // [152]
  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
