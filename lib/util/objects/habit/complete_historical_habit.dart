import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:provider/provider.dart';

completeHistoricalHabitDialog(
    int index, BuildContext context, DateTime time, bool isToday) {
  bool amountCheck = false;

  var habit =
      context.read<HistoricalHabitProvider>().getHistoricalHabitAt(index, time);

  if (habit.amount > 1) amountCheck = true;

  int theAmountValue = habit.amountCompleted;
  int theDurationValueHours = habit.durationCompleted ~/ 60;
  int theDurationValueMinutes = habit.durationCompleted % 60;

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
                          max: habit.amount - 1,
                          value: theAmountValue.toDouble(),
                          onChanged: (value) => mystate(() {
                            HapticFeedback.lightImpact();
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
                                color: Colors.white38,
                                fontWeight: FontWeight.bold,
                              ),
                              labelText: AppLocale.hours.getString(context),
                            ),
                            min: 0,
                            max: (habit.duration ~/ 60).toDouble(),
                            value: theDurationValueHours.toDouble(),
                            onChanged: (value) => mystate(() {
                              HapticFeedback.lightImpact();
                              theDurationValueHours = value.toInt();
                              if (theDurationValueHours ==
                                  (habit.duration ~/ 60)) {
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
                              fontWeight: FontWeight.bold,
                            ),
                            labelText: AppLocale.minutes.getString(context),
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
                            if (isToday) {
                              context
                                  .read<HabitProvider>()
                                  .completeHabitProvider(index, false, false);
                            }
                            context
                                .read<HistoricalHabitProvider>()
                                .completeHistoricalHabit(
                                    index, habit, time, context);

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
                                if (isToday) {
                                  context
                                      .read<HabitProvider>()
                                      .applyAmountCompleted(
                                          index, theAmountValue);
                                }
                                context
                                    .read<HistoricalHabitProvider>()
                                    .applyHistoricalAmountCompleted(
                                        habit, theAmountValue, time, index);
                              } else {
                                if (isToday) {
                                  context
                                      .read<HabitProvider>()
                                      .applyDurationCompleted(
                                          index,
                                          theDurationValueHours,
                                          theDurationValueMinutes);
                                }
                                context
                                    .read<HistoricalHabitProvider>()
                                    .applyHistoricalDurationCompleted(
                                        habit,
                                        theDurationValueHours,
                                        theDurationValueMinutes,
                                        time,
                                        index);
                              }
                              Navigator.pop(context);
                            });
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
                            fillColor: context.watch<ColorProvider>().greyColor,
                          ),
                          min: 0,
                          max: habit.amount - 1,
                          value: theAmountValue.toDouble(),
                          onChanged: (value) => mystate(() {
                            HapticFeedback.lightImpact();
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
                            iconColor:
                                WidgetStateProperty.all<Color>(Colors.white),
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
                              fillColor:
                                  context.watch<ColorProvider>().greyColor,
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
                              HapticFeedback.lightImpact();
                              theDurationValueHours = value.toInt();
                              if (theDurationValueHours ==
                                  (habit.duration ~/ 60)) {
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
                          iconColor:
                              WidgetStateProperty.all<Color>(Colors.white),
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
                            fillColor: context.watch<ColorProvider>().greyColor,
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
              );

              return CupertinoAlertDialog(
                content: child,
                actions: [
                  CupertinoDialogAction(
                    child: Text(AppLocale.done.getString(context)),
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
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocale.enter.getString(context)),
                    onPressed: () {
                      mystate(() {
                        if (amountCheck) {
                          if (isToday) {
                            context
                                .read<HabitProvider>()
                                .applyAmountCompleted(index, theAmountValue);
                          }
                          context
                              .read<HistoricalHabitProvider>()
                              .applyHistoricalAmountCompleted(
                                  habit, theAmountValue, time, index);
                        } else {
                          if (isToday) {
                            context
                                .read<HabitProvider>()
                                .applyDurationCompleted(
                                    index,
                                    theDurationValueHours,
                                    theDurationValueMinutes);
                          }
                          context
                              .read<HistoricalHabitProvider>()
                              .applyHistoricalDurationCompleted(
                                  habit,
                                  theDurationValueHours,
                                  theDurationValueMinutes,
                                  time,
                                  index);
                        }
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              );
            }));
  }
}
