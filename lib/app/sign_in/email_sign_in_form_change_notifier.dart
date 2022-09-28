// * [263] - This is the new file

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker/services/auth.dart';

import '../../common_widgets/form_submit_button.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
import 'email_sign_in_model.dart';

//_____________________________________________________________________________
// * [263] - Implementing ChangeNotifier instead of BLoC
//
// 1. rename EmailSignInFormBlocBased -> EmailSignInFormChangeNotifier
// 2. change argument -> EmailSignInChangeNotifier [line - ]
//    so it takes EmailSignInChangeNotifier rather than BLoC as an argument
// 3. Provider -> ChangeNotifierProvider [lines - ]
// 4. ChangeNotifierProvider - creates a model class type EmailSignInChangeModel
//    Then we configue our Consumer of EmailSignInChangeModel
// *  builder of it will be called everytime when we notifyListeners()
// *  inside of our model class
//
// 5. remove StreamBuilder in "build" method
//    model is property of our Stateful Widget class.
//    access it through widget.model
//    remove model argument from all internal methods (ex: _buildChildren)
//_____________________________________________________________________________

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({super.key, required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // * instead of using widget.model everywhere - use get
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  //----------------------------------------------------------------------------
  // Methods for buttons - [248]
  //----------------------------------------------------------------------------
  Future<void> _submit() async {
    try {
      await model.submit();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  //----------------------------------------------------------------------------
  // Email & Password Methods
  //----------------------------------------------------------------------------

  // [201] - if email is invalid - keep the focus on the field
  void _emailEditingComplete() {
    // this code will choose _passwordFocusNode is email is valid
    // and emailFocusNode if the email is not valid
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  //----------------------------------------------------------------------------
  // Email & Password Forms
  //----------------------------------------------------------------------------

  Widget _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      controller: _emailController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: (email) => model.updateEmail(email),
    );
  }

  Widget _buildEmailPasswordField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: (password) => model.updatePassword(password),
    );
  }

  //----------------------------------------------------------------------------
  // Children widgets
  //----------------------------------------------------------------------------

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      const SizedBox(height: 8.0),
      _buildEmailPasswordField(),
      const SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(height: 8.0),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
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
