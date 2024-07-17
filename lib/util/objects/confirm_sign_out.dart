import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/auth_service.dart';

Widget confirmSignOut(context) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: theYellowColor, width: 3.0),
      ),
      backgroundColor: Colors.black,
      title: const Text(
        textAlign: TextAlign.center,
        'Are you sure you want to sign out?',
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(120, 50),
                    ),
                    backgroundColor: WidgetStatePropertyAll(theYellowColor)),
                onPressed: () {
                  AuthService().signOut(context);
                },
                child: const Text(
                  "Sign out",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
            OutlinedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(120, 50),
                    ),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: theYellowColor,
                      width: 3.0,
                    )),
                    backgroundColor: WidgetStatePropertyAll(Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
          ],
        )
      ],
    ),
  );
}
