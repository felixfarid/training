import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  // const CustomRaisedButton({super.key});
  CustomRaisedButton({
    required this.child,
    required this.borderRadius,
    required this.color,
    this.height = 50,
    this.onPressed,
  });

  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback? onPressed;
  final double height;
  // Stateless widget has final, immutable properties

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
