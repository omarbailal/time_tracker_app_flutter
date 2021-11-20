import 'package:flutter/material.dart';

Future<bool> showAlertDialog(
  BuildContext context,{
  required String title,
  required String content,
  required String defaultActionText,
  String? cancelActionText,
}){
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if(cancelActionText != null)
          FlatButton(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        FlatButton(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  ).then((value) => value ?? false);

}