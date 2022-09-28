import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';

// * [259] - since this file doesn't use Stream anymore
// * [259] - we cannot call is bloc
// * [259] - instead change name to SignInManager

// [232]
class SignInManager {
  // [238] - moving authentication to bloc
  SignInManager({required this.auth, required this.isLoading});
  final AuthBase auth;

  final ValueNotifier<bool> isLoading; // [257]

  // [257]
  // ValueNotifier will be used instead of StreamController.

  // [238] - move authentication logic in here
  // create a method which will take a function as an argument
  //
  // we are passing Function() which returns future as an argument
  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      isLoading.value = true; // [257]
      return await signInMethod();
    } catch (e) {
      isLoading.value = false; // [257]
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
