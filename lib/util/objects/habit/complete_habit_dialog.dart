import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';

import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:provider/provider.dart';

completeHabitDialog(
  int index,
  bool isAdLoaded,
  interstitialAd,
  BuildContext context,
) {
  bool amountCheck = false;

  if (habitBox.getAt(index)!.amount > 1) amountCheck = true;

  int theAmountValue = habitBox.getAt(index)!.amountCompleted;
  int theDurationValueHours = habitBox.getAt(index)!.durationCompleted ~/ 60;
  int theDurationValueMinutes = habitBox.getAt(index)!.durationCompleted % 60;

  if (Platform.isAndroid) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, mystate) {
              Widget child = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (amountCheck)
                    Column(
                      children: [
                        SpinBox(
                          cursorColor: Colors.white,
                          iconColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            filled: true,
                            fillColor: context.watch<ColorProvider>().greyColor,
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
                            iconColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              filled: true,
                              fillColor:
                                  context.watch<ColorProvider>().greyColor,
                              labelStyle: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              labelText: AppLocale.hours.getString(context),
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
                                    (habitBox.getAt(index)!.duration % 60 -
                                        1)) {
                                  theDurationValueMinutes =
                                      (habitBox.getAt(index)!.duration % 60 -
                                          1);
                                }
                              }
                            }),
                          ),
                        const SizedBox(height: 10),
                        SpinBox(
                          cursorColor: Colors.white,
                          iconColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            filled: true,
                            fillColor: context.watch<ColorProvider>().greyColor,
                            labelStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white38,
                                fontWeight: FontWeight.bold),
                            labelText: AppLocale.minutes.getString(context),
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
              );

              return AlertDialog(
                content: child,
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CupertinoDialogAction(
                          child: Text(
                            AppLocale.done.getString(context),
                            style: const TextStyle(fontFamily: "Poppins"),
                          ),
                          onPressed: () {
                            context.read<HabitProvider>().completeHabitProvider(
                                index, isAdLoaded, interstitialAd);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: CupertinoDialogAction(
                          child: Text(
                            AppLocale.enter.getString(context),
                            style: const TextStyle(fontFamily: "Poppins"),
                          ),
                          onPressed: () {
                            mystate(() {
                              if (amountCheck) {
                                context
                                    .read<HabitProvider>()
                                    .applyAmountCompleted(
                                        index, theAmountValue);
                              } else {
                                context
                                    .read<HabitProvider>()
                                    .applyDurationCompleted(
                                        index,
                                        theDurationValueHours,
                                        theDurationValueMinutes);
                              }
                              saveHabitsForToday();
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }));
  } else {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, mystate) {
              Widget child = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (amountCheck)
                    Column(
                      children: [
                        SpinBox(
                          cursorColor: Colors.white,
                          iconColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            filled: false,
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
                            iconColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              filled: false,
                              labelStyle: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              labelText: AppLocale.hours.getString(context),
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
                                    (habitBox.getAt(index)!.duration % 60 -
                                        1)) {
                                  theDurationValueMinutes =
                                      (habitBox.getAt(index)!.duration % 60 -
                                          1);
                                }
                              }
                            }),
                          ),
                        const SizedBox(height: 10),
                        SpinBox(
                          cursorColor: Colors.white,
                          iconColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            filled: false,
                            labelStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white38,
                                fontWeight: FontWeight.bold),
                            labelText: AppLocale.minutes.getString(context),
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
              );

              return CupertinoAlertDialog(
                content: child,
                actions: [
                  CupertinoDialogAction(
                    child: Text(AppLocale.done.getString(context)),
                    onPressed: () {
                      context.read<HabitProvider>().completeHabitProvider(
                          index, isAdLoaded, interstitialAd);
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocale.enter.getString(context)),
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
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }));
  }
}
