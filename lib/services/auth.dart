import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  Future<User?> signInWithGoogle(); // [161]
  Future<void> signOut();
  Stream<User?> authStateChanges();
  Future<User?> signInWithEmailAndPassword(
      String email, String password); //[189]
  Future<User?> createUserWithEmailAndPassword(
      String email, String password); //[189]
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

  // [161]
  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleSignIn != null) {
      // get access token
      final googlAuth = await googleUser?.authentication;
      // check if google auth is not equal to null
      if (googlAuth?.idToken != null) {
        final userCredentials = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googlAuth?.idToken,
            accessToken: googlAuth?.accessToken,
          ),
        );
        return userCredentials.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  //! problem could be in signInWithEmailAndPassword

  // [189]
  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredentials.user;
  }

  //[189]
  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredentials.user;
  }

  @override
  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn(); //[165]
    await googleSignIn.signOut(); //[165]
    await _firebaseAuth.signOut();
  }
}
