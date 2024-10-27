import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/colors.dart';

Widget deleteTagWidget(int tag, context) {
  return AlertDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      side: BorderSide(color: AppColors.theRedColor, width: 3.0),
    ),
    backgroundColor: Colors.black,
    title: Text(
      textAlign: TextAlign.center,
      "Are you sure you want to delete '${tagBox.getAt(tag)!.tag}'?",
      style: const TextStyle(fontSize: 20),
    ),
    actions: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                    Size(110, 50),
                  ),
                  backgroundColor: WidgetStatePropertyAll(AppColors.theRedColor)),
              onPressed: () {
                for (int i = 0; i < tagBox.length; i++) {
                  if (tagBox.getAt(i)!.tag == tagBox.getAt(tag)!.tag) {
                    tagBox.getAt(i)!.tag = "No tag";
                  }
                }

                tagBox.deleteAt(tag);

                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(fontSize: 14, color: Colors.white),
              )),
          OutlinedButton(
              style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                    Size(110, 50),
                  ),
                  side: WidgetStatePropertyAll(BorderSide(
                    color: AppColors.theRedColor,
                    width: 3.0,
                  )),
                  backgroundColor: WidgetStatePropertyAll(Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 14, color: Colors.white),
              )),
        ],
      )
    ],
  );
}
