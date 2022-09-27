import 'dart:async';

import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';

import '../../services/auth.dart';

// [244]

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  // ignore: prefer_final_fields
  EmailSignInModel _model = EmailSignInModel();

  //----------------------------------------------------------------------------
  // Dispose method
  //----------------------------------------------------------------------------

  void dispose() {
    _modelController.close();
  }
  //----------------------------------------------------------------------------
  // Updating email & passwrod
  //----------------------------------------------------------------------------

  // [249]

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String passwrod) => updateWith(password: passwrod);

  //----------------------------------------------------------------------------
  // Updating model method
  //----------------------------------------------------------------------------

  // [245]
  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }

  //----------------------------------------------------------------------------
  // Submit method - [246]
  //----------------------------------------------------------------------------

  Future<void> submit() async {
    // [246]
    // instead of setState we will use _updateWith method.

    updateWith(submitted: true, isLoading: true);

    //[190]
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
      // dismiss the page once the log in or registration is successful
      // ignore: use_build_context_synchronously
      // [220] - code will only execute on exceptions type - firebase
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  //----------------------------------------------------------------------------
  // Toggle between Login and Registration
  //----------------------------------------------------------------------------

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
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
}
