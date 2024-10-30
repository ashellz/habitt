import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showCustomDialog(
  BuildContext context,
  String title,
  Widget child,
  givenFunction,
  String buttonTextAffirmative,
  String buttonTextNegative,
) {
  if (Platform.isAndroid) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: child,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CupertinoDialogAction(
                        child: Text(
                          buttonTextNegative,
                          style: const TextStyle(fontFamily: "Poppins"),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: CupertinoDialogAction(
                        child: Text(
                          buttonTextAffirmative,
                          style: const TextStyle(fontFamily: "Poppins"),
                        ),
                        onPressed: () {
                          givenFunction();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ));
  } else {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: child,
              actions: [
                CupertinoDialogAction(
                  child: Text(buttonTextNegative),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: Text(buttonTextAffirmative),
                  onPressed: () {
                    givenFunction();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
