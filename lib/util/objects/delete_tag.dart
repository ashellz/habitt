import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/new_home_page.dart';

Widget deleteTagWidget(tag) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: theRedColor, width: 3.0),
      ),
      backgroundColor: Colors.black,
      title: Text(
        textAlign: TextAlign.center,
        "Are you sure you want to delete '$tag'?",
        style: const TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    backgroundColor: WidgetStatePropertyAll(theRedColor)),
                onPressed: () {
                  print(tagsBox.get(tag));
                  try {
                    tagsBox.delete(tag);
                  } catch (e) {
                    print(e);
                  }

                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
            OutlinedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: theRedColor,
                      width: 3.0,
                    )),
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.black)),
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
    ),
  );
}
