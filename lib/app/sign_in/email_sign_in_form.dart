import 'package:flutter/material.dart';

import '../../common_widgets/form_submit_button.dart';

class EmailSignInForm extends StatelessWidget {
  const EmailSignInForm({super.key});

  List<Widget> _buildChildren() {
    return [
      const TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
        ),
      ),
      const SizedBox(height: 8.0),
      const TextField(
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      const SizedBox(height: 8.0),
      FormSubmitButton(
        text: 'Sign In',
        onPressed: () {},
      ),
      const SizedBox(height: 8.0),
      TextButton(
        onPressed: () {},
        child: const Text(
          'Need an account? Register',
        ),
      )
    ];
  }

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
