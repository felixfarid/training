// [243]
import 'package:time_tracker/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  // [250]

  //----------------------------------------------------------------------------
  // Model for toggling Login vs Registration
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

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  // [250]
  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  // [250]
  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  // [245]
  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      // ?? conditional operator that returns value
      // to the left if it's not null. If yes then right
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  // model.copyWith(email: email)
  // if passed email is not null then add it.
  // but othen parameters such as password and formType
  // will be taken from model (that were added previously)
}
