import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/CommonWidgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton{
  FormSubmitButton({
    required String text,
    required var onPressed,
}) : super(
  child: Text(
    text,
    style: TextStyle(color: Colors.white, fontSize: 20.0)
    ),
    color: Colors.indigo,
    height: 40.0,
    borderRaduis: 4.0,
    onPressed: onPressed,
  );
}