import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

// this class does not declare any properties at all
// that's why constructor was not used

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    required String asset,
    required String text,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onPressed,
    required double borderRadius,
    double fontSize = 14,
  })  : assert(text != null),
        assert(asset != null),
        // helps to diagnose the code. Showing exactly where the problem is
        super(
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(asset),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
          borderRadius: borderRadius,
        );
}
