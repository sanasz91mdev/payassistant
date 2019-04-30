
import 'dart:async';
import 'package:flutter/material.dart';

Future showAlertDialog(
    BuildContext context, String title, String message) async {
  await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
          title: Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
                onPressed: () => Navigator.pop(context),
                child: new Text('OK'))
          ],
        ),
  );
}

Future showAlertDialogAndRoute(
    BuildContext context, String title, String message, String route) async {
  await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
          title: Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  switch (route) {
                    case 'home':
                                          Navigator.pop(context);
                      break;
                    default:
                      Navigator.pop(context);
                  }
                },
                child: new Text('OK'))
          ],
        ),
  );
}
