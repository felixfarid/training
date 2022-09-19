import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

// this class does not declare any properties at all
// that's why constructor was not used

class SignInButton extends CustomRaisedButton {
  SignInButton({
    required String text,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onPressed,
    required double borderRadius,
    double fontSize = 14,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
          color: color,
          onPressed: onPressed,
          borderRadius: borderRadius,
        );
}
