import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/custom_raised_button.dart';

class SignInButtonLogo extends CustomRaisedButton{

  SignInButtonLogo({
    required String assetName,
    required String text,
    required Color color,
    required Color textColor,
    required double borderRaduis,
    required var onPressed,
  }) : super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(assetName),
        Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),),
        Opacity(
            opacity: 0.0,
            child: Image.asset(assetName)
        )
      ]
    ),
    color: color,
    borderRaduis: borderRaduis,
    onPressed: onPressed,
  );

}