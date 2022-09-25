import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/services/auth.dart';

import '../../common_widgets/form_submit_button.dart';
import '../../common_widgets/show_alert_dialog.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';

enum EmailSignInFormType { signIn, register }

//[196] - added mixin
class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({super.key});

  //// final AuthBase auth; //[189]

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  // depending on the formType we will customize the text that
  // we show inside our button
  EmailSignInFormType _formType = EmailSignInFormType.signIn; //[188]

  //[188]
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //[190]
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  //[193]
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //[198]
  bool _submitted = false;

  //[200]
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // Methods for buttons
  //----------------------------------------------------------------------------
  void _submit() async {
    //[198]
    setState(() {
      _submitted = true;
      //[200]
      _isLoading = true;
    });
    //[190]
    try {
      //// final auth = AuthProvider.of(context); //[215]
      final auth = Provider.of<AuthBase>(context, listen: false); //[217]
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      // dismiss the page once the log in or registration is successful
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // [220] - code will only execute on exceptions type - firebase
    } on FirebaseAuthException catch (e) {
      // [220]
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      // we want the loading to end when
      // we either successfully submit or get error
      // [200]
      setState(() {
        _isLoading = false;
      });
    }
  }

  //[188]
  // toggling between sign in and registration
  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    // to clean the fields
    _emailController.clear();
    _passwordController.clear();
  }

  //----------------------------------------------------------------------------
  // Email & Password Methods
  //----------------------------------------------------------------------------

  //[193]
  //[201] - if email is invalid - keep the focus on the field
  void _emailEditingComplete() {
    // this code will choose _passwordFocusNode is email is valid
    // and emailFocusNode if the email is not valid
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  //[194]
  void _updateEmailState() {
    // since the value of (submitEnabled) changes
    // here we just need to quickly rebuild
    setState(() {});
  }

  //----------------------------------------------------------------------------
  // Email & Password Forms
  //----------------------------------------------------------------------------
  // [192]
  Widget _buildEmailTextField() {
    //[198]
    // if Editing was complete and the field is still empty
    // through an errors
    bool showEmailErrorText =
        _submitted && !widget.emailValidator.isValid(_email); //[197]

    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText:
            showEmailErrorText ? widget.invalidEmailErrorText : null, //[197]
        enabled: _isLoading == false, //[200]
      ),
      controller: _emailController,
      autocorrect: false, //[192]
      keyboardType: TextInputType.emailAddress, //[192]
      textInputAction: TextInputAction.next, //[192]
      focusNode: _emailFocusNode, //[193]
      onEditingComplete: _emailEditingComplete, //[193]
      onChanged: (email) => _updateEmailState(), //[194]
    );
  }

  // [192]
  Widget _buildEmailPasswordField() {
    //[198]
    bool showPasswordErrorText =
        _submitted && !widget.passwordValidator.isValid(_password); //[197]

    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showPasswordErrorText
            ? widget.invalidPasswordErrorText
            : null, //[197]
        enabled: _isLoading == false, //[200]
      ),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done, //[192]
      focusNode: _passwordFocusNode, //[193]
      onEditingComplete: _submit,
      onChanged: (password) => _updateEmailState(), //[194]
    );
  }

  //----------------------------------------------------------------------------
  // Children widgets
  //----------------------------------------------------------------------------
  //[188]
  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';

    // [196]
    // enable the button when the email and password is in place
    // and loading is true
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.emailValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      const SizedBox(height: 8.0),
      _buildEmailPasswordField(),
      const SizedBox(height: 8.0),
      FormSubmitButton(
        text: primaryText,
        // onPressed: _submit,
        onPressed: submitEnabled ? _submit : null, //[194]
      ),
      const SizedBox(height: 8.0),
      //[188]
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null, //[200]
        child: Text(secondaryText),
      )
    ];
  }

  //----------------------------------------------------------------------------
  // BUILD
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
