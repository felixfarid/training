// * [260] - This is the new file
// * [260] - Created to show how ChangeNotifier is used

import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_model.dart';

//_____________________________________________________________________________
// *  [260] - Implementing ChangeNotifier instead of BLoC
//
// 1. add a ChangeNotifier as a mixin
// 2. We need to make all variables mutable.
//    In BLoC we made variables immutable
//    whenever we wanted to update the model,
//    we would make the changes with [.copyWith]
//    and we would add resulting model to the StreamController.
//
//    Our new implementation
//    will not use Streams of immutable values
//    Instead, when we work with ChangeNotifier
//    We will have just one model and the properties of it can change
//
// 3. delete final attribute from all variables
// 4. add a method that we can use to update them
//  4.1 copyWith -> updateWith -> return type just void
// 5. add it's listener in (updateWith) - notifyListeners()
//  5.1 emailSignInForm - will be listener for this model
//
// * [261] - Copy usefull methods from email_sign_in_bloc
//
// 6. copy - toggleFormType, updateEmail, updatePassword, submit
// 7. we need to use "auth" in "submit" method
// 8. add "auth" property to this class
//_____________________________________________________________________________

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
    required this.auth, // [261]
  });

  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  final AuthBase auth; // [261]

  //----------------------------------------------------------------------------
  // Toggling Login vs Registration
  //----------------------------------------------------------------------------

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';
  }

  // [260] - copied from email_sign_in_bloc

  void toggleFormType() {
    // replaced "_model" with "this"
    // "this" is used to differentiate the formType instance variable
    // from local one
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      submitted: false,
      isLoading: false,
      formType: formType,
    );
  }

  //----------------------------------------------------------------------------
  // Validators
  //----------------------------------------------------------------------------

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  //----------------------------------------------------------------------------
  // Errors in the fields
  //----------------------------------------------------------------------------

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  //----------------------------------------------------------------------------
  // updating the model with new variables (email, password etc.)
  //----------------------------------------------------------------------------

  // ======================================================================
  // | How it works
  // | updateWith(email: email)
  // | if passed email is not null then add it.
  // | but othen parameters such as password and formType
  // | will be taken from model (that were added previously)
  // ======================================================================

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    // ?? conditional operator that returns value
    // to the left if it's not null. If yes then right
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    // [260] - notifies all of it's listeners
    notifyListeners();
  }

  //----------------------------------------------------------------------------
  // Updating email & passwrod
  //----------------------------------------------------------------------------

  // [260] - copied from email_sign_in_bloc

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String passwrod) => updateWith(password: passwrod);

  //----------------------------------------------------------------------------
  // Submit method
  //----------------------------------------------------------------------------

  // [260] - copied from email_sign_in_bloc
  //         fix references to model because the properties
  //         are already stored in this class
  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
