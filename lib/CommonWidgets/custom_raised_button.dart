
import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    required this.child,
    required this.color,
    required this.borderRaduis,
    required this.onPressed,
    this.height: 50.0,
  });

  final Widget child;
  final Color color;
  final double borderRaduis;
  final VoidCallback onPressed;
  final double height;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(borderRaduis)
            )
        ),
        onPressed: onPressed,
      ),
    );
  }
}
