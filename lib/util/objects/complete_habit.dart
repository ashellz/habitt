import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

Widget completeHabitDialog(int index) {
  bool amountCheck = false;

  if (habitBox.getAt(index)!.amount > 1) amountCheck = true;

  int theAmountValue = habitBox.getAt(index)!.amountCompleted;
  int theDurationValueHours = habitBox.getAt(index)!.durationCompleted ~/ 60;
  int theDurationValueMinutes = habitBox.getAt(index)!.durationCompleted % 60;

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: theLightGreen, width: 3.0),
      ),
      backgroundColor: Colors.black,
      content: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (amountCheck)
                Column(
                  children: [
                    SpinBox(
                      cursorColor: Colors.white,
                      iconColor: WidgetStateProperty.all<Color>(Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                      ),
                      min: 0,
                      max: habitBox.getAt(index)!.amount - 1,
                      value: theAmountValue.toDouble(),
                      onChanged: (value) => mystate(() {
                        Vibration.vibrate(duration: 10);
                        theAmountValue = value.toInt();
                      }),
                    ),
                    const SizedBox(height: 5),
                    Text(habitBox.getAt(index)!.amountName)
                  ],
                ),
              if (!amountCheck)
                Column(
                  children: [
                    if (habitBox.getAt(index)!.duration > 60)
                      SpinBox(
                        cursorColor: Colors.white,
                        iconColor: WidgetStateProperty.all<Color>(Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          labelStyle: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white38,
                              fontWeight: FontWeight.bold),
                          labelText: "HOURS",
                        ),
                        min: 0,
                        max: (habitBox.getAt(index)!.duration ~/ 60).toDouble(),
                        value: theDurationValueHours.toDouble(),
                        onChanged: (value) => mystate(() {
                          Vibration.vibrate(duration: 10);
                          theDurationValueHours = value.toInt();
                          if (theDurationValueHours ==
                              (habitBox.getAt(index)!.duration ~/ 60)) {
                            if (theDurationValueMinutes >
                                (habitBox.getAt(index)!.duration % 60 - 1)) {
                              theDurationValueMinutes =
                                  (habitBox.getAt(index)!.duration % 60 - 1);
                            }
                          }
                        }),
                      ),
                    const SizedBox(height: 10),
                    SpinBox(
                      cursorColor: Colors.white,
                      iconColor: WidgetStateProperty.all<Color>(Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        labelStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white38,
                            fontWeight: FontWeight.bold),
                        labelText: "MINUTES",
                      ),
                      min: 0,
                      max: theDurationValueHours.toDouble() <
                              habitBox.getAt(index)!.duration ~/ 60
                          ? 59
                          : habitBox.getAt(index)!.duration % 60 - 1,
                      value: theDurationValueMinutes.toDouble(),
                      onChanged: (value) => mystate(() {
                        theDurationValueMinutes = value.toInt();
                      }),
                    ),
                  ],
                ),
            ],
          ),
        ),
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
                    backgroundColor: WidgetStatePropertyAll(theLightGreen)),
                onPressed: () {
                  context.read<HabitProvider>().completeHabitProvider(index);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
            OutlinedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: theLightGreen,
                      width: 3.0,
                    )),
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.black)),
                onPressed: () {
                  mystate(() {
                    if (amountCheck) {
                      applyAmountCompleted(index, theAmountValue);
                    } else {
                      applyDurationCompleted(index, theDurationValueHours,
                          theDurationValueMinutes);
                    }
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  "Enter",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
          ],
        )
      ],
    ),
  );
}

applyDurationCompleted(
    index, int theDurationValueHours, int theDurationValueMinutes) {
  habitBox.putAt(
      index,
      HabitData(
          name: habitBox.getAt(index)!.name,
          completed: habitBox.getAt(index)!.completed,
          icon: habitBox.getAt(index)!.icon,
          category: habitBox.getAt(index)!.category,
          streak: habitBox.getAt(index)!.streak,
          amount: habitBox.getAt(index)!.amount,
          amountName: habitBox.getAt(index)!.amountName,
          amountCompleted: habitBox.getAt(index)!.amountCompleted,
          duration: habitBox.getAt(index)!.duration,
          durationCompleted:
              theDurationValueHours * 60 + theDurationValueMinutes,
          skipped: habitBox.getAt(index)!.skipped,
          tag: habitBox.getAt(index)!.tag));
}

applyAmountCompleted(index, theAmountValue) {
  habitBox.putAt(
      index,
      HabitData(
          name: habitBox.getAt(index)!.name,
          completed: habitBox.getAt(index)!.completed,
          icon: habitBox.getAt(index)!.icon,
          category: habitBox.getAt(index)!.category,
          streak: habitBox.getAt(index)!.streak,
          amount: habitBox.getAt(index)!.amount,
          amountName: habitBox.getAt(index)!.amountName,
          amountCompleted: theAmountValue,
          duration: habitBox.getAt(index)!.duration,
          durationCompleted: habitBox.getAt(index)!.durationCompleted,
          skipped: habitBox.getAt(index)!.skipped,
          tag: habitBox.getAt(index)!.tag));
}
