import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/services/auth.dart';

import '../../common_widgets/form_submit_button.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
import 'email_sign_in_model.dart';

//[196] - added mixin
class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({super.key, required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSignInFormBlocBased> createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  //[188]
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //[193]
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
      await widget.bloc.submit();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // [220]
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  //----------------------------------------------------------------------------
  // Email & Password Methods
  //----------------------------------------------------------------------------

  //[193]
  //[201] - if email is invalid - keep the focus on the field
  void _emailEditingComplete(EmailSignInModel model) {
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
  // [192]
  Widget _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText, //[250]
        enabled: model.isLoading == false, //[200]
      ),
      controller: _emailController,
      autocorrect: false, //[192]
      keyboardType: TextInputType.emailAddress, //[192]
      textInputAction: TextInputAction.next, //[192]
      focusNode: _emailFocusNode, //[193]
      onEditingComplete: () => _emailEditingComplete(model), //[193]
      onChanged: (email) => widget.bloc.updateEmail(email), // [249]
    );
  }

  // [192]
  Widget _buildEmailPasswordField(EmailSignInModel model) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText, //[250]
        enabled: model.isLoading == false, //[200]
      ),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done, //[192]
      focusNode: _passwordFocusNode, //[193]
      onEditingComplete: _submit,
      onChanged: (password) => widget.bloc.updatePassword(password), // [249]
    );
  }

  //----------------------------------------------------------------------------
  // Children widgets
  //----------------------------------------------------------------------------
  //[188]
  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      const SizedBox(height: 8.0),
      _buildEmailPasswordField(model),
      const SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        // onPressed: _submit,
        onPressed: model.canSubmit ? _submit : null, //[194]
      ),
      const SizedBox(height: 8.0),
      //[188]
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null, //[200]
        child: Text(model.secondaryButtonText),
      )
    ];
  }

  //----------------------------------------------------------------------------
  // BUILD
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
