import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton{

  SignInButton({
    required String text,
    required Color color,
    required Color textColor,
    required double borderRaduis,
    required var onPressed,
  }) : super(
          child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          borderRaduis: borderRaduis,
          onPressed: onPressed,
        );

}