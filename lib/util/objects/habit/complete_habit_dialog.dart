import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:provider/provider.dart';

Widget completeHabitDialog(int index, bool isAdLoaded, interstitialAd) {
  bool amountCheck = false;

  if (habitBox.getAt(index)!.amount > 1) amountCheck = true;

  int theAmountValue = habitBox.getAt(index)!.amountCompleted;
  int theDurationValueHours = habitBox.getAt(index)!.durationCompleted ~/ 60;
  int theDurationValueMinutes = habitBox.getAt(index)!.durationCompleted % 60;

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: AppColors.theLightColor, width: 3.0),
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
                        if (boolBox.get('hapticFeedback')!) {
                          HapticFeedback.lightImpact();
                        }
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
                        max: (habitBox.getAt(index)!.duration ~/ 60) - 1,
                        value: theDurationValueHours.toDouble(),
                        onChanged: (value) => mystate(() {
                          if (boolBox.get('hapticFeedback')!) {
                            HapticFeedback.lightImpact();
                          }

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
                        if (boolBox.get('hapticFeedback')!) {
                          HapticFeedback.lightImpact();
                        }
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
                style: const ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.theLightColor)),
                onPressed: () {
                  context
                      .read<HabitProvider>()
                      .completeHabitProvider(index, isAdLoaded, interstitialAd);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
            OutlinedButton(
                style: const ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: AppColors.theLightColor,
                      width: 3.0,
                    )),
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.black)),
                onPressed: () {
                  mystate(() {
                    if (amountCheck) {
                      context
                          .read<HabitProvider>()
                          .applyAmountCompleted(index, theAmountValue);
                    } else {
                      context.read<HabitProvider>().applyDurationCompleted(
                          index,
                          theDurationValueHours,
                          theDurationValueMinutes);
                    }
                    saveHabitsForToday();
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
