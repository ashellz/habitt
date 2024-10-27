import 'package:flutter/material.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

Widget confirmDeleteHabit(int index, TextEditingController editcontroller) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: Colors.grey.shade900, width: 3.0),
      ),
      backgroundColor: Colors.black,
      title: Center(
        child: RichText(
          text: const TextSpan(children: <TextSpan>[
            TextSpan(
              text: "You will lose all your progress and data on this habit.",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
              ),
            ),
            TextSpan(
                text: " This won't affect this habit in the past.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: "Poppins",
                )),
          ]),
        ),
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            width: 100,
            child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 2.0, color: Colors.grey.shade800),
                ),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 14))),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 100,
            child: ElevatedButton(
                onPressed: () {
                  context
                      .read<HabitProvider>()
                      .deleteHabitProvider(index, context, editcontroller);
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(AppColors.theRedColor),
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
          ),
        ]),
      ],
    ),
  );
}
    
    /*AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: theRedColor, width: 3.0),
      ),
      backgroundColor: Colors.black,
      title: const Text(
        textAlign: TextAlign.center,
        "Are you sure you want to delete this habit?",
        style: TextStyle(fontSize: 20),
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
                  context
                      .read<HabitProvider>()
                      .deleteHabitProvider(index, context, editcontroller);
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
  );*/


    
