import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/services/provider/historical_habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

Widget completeHistoricalHabitDialog(
    int index, BuildContext context, DateTime time, bool isToday) {
  bool amountCheck = false;

  var habit =
      context.read<HistoricalHabitProvider>().getHistoricalHabitAt(index, time);

  if (habit.amount > 1) amountCheck = true;

  int theAmountValue = habit.amountCompleted;
  int theDurationValueHours = habit.durationCompleted ~/ 60;
  int theDurationValueMinutes = habit.durationCompleted % 60;

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: theLightColor, width: 3.0),
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
                      max: habit.amount - 1,
                      value: theAmountValue.toDouble(),
                      onChanged: (value) => mystate(() {
                        Vibration.vibrate(duration: 10);
                        theAmountValue = value.toInt();
                      }),
                    ),
                    const SizedBox(height: 5),
                    Text(habit.amountName)
                  ],
                ),
              if (!amountCheck)
                Column(
                  children: [
                    if (habit.duration > 60)
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
                        max: (habit.duration ~/ 60).toDouble(),
                        value: theDurationValueHours.toDouble(),
                        onChanged: (value) => mystate(() {
                          Vibration.vibrate(duration: 10);
                          theDurationValueHours = value.toInt();
                          if (theDurationValueHours == (habit.duration ~/ 60)) {
                            if (theDurationValueMinutes >
                                (habit.duration % 60 - 1)) {
                              theDurationValueMinutes =
                                  (habit.duration % 60 - 1);
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
                              habit.duration ~/ 60
                          ? 59
                          : habit.duration % 60 - 1,
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
                    backgroundColor: WidgetStatePropertyAll(theLightColor)),
                onPressed: () {
                  if (isToday) {
                    context
                        .read<HabitProvider>()
                        .completeHabitProvider(index, false, false);
                  }
                  context
                      .read<HistoricalHabitProvider>()
                      .completeHistoricalHabit(index, habit, time, context);

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
                      color: theLightColor,
                      width: 3.0,
                    )),
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.black)),
                onPressed: () {
                  mystate(() {
                    if (amountCheck) {
                      if (isToday) {
                        context
                            .read<HabitProvider>()
                            .applyAmountCompleted(index, theAmountValue);
                      } else {
                        context
                            .read<HistoricalHabitProvider>()
                            .applyHistoricalAmountCompleted(
                                habit, theAmountValue, time, index);
                      }
                    } else {
                      if (isToday) {
                        context.read<HabitProvider>().applyDurationCompleted(
                            index,
                            theDurationValueHours,
                            theDurationValueMinutes);
                      } else {
                        context
                            .read<HistoricalHabitProvider>()
                            .applyHistoricalDurationCompleted(
                                habit,
                                theDurationValueHours,
                                theDurationValueMinutes,
                                time,
                                index);
                      }
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
