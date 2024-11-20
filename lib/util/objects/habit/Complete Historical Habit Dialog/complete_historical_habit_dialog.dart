import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:habitt/util/objects/habit/Complete%20Historical%20Habit%20Dialog/android_complete_historical_dialog.dart';
import 'package:habitt/util/objects/habit/Complete%20Historical%20Habit%20Dialog/cupertino_complete_historical_dialog.dart';
import 'package:provider/provider.dart';

completeHistoricalHabitDialog(
    int index, BuildContext context, DateTime time, bool isToday) {
  bool amountCheck = false;

  var habit =
      context.read<HistoricalHabitProvider>().getHistoricalHabitAt(index, time);

  if (habit.amount > 1) amountCheck = true;

  context.read<DataProvider>().setAmountValue(habit.amountCompleted);
  context
      .read<DataProvider>()
      .setDurationValueHours(habit.durationCompleted ~/ 60);
  context
      .read<DataProvider>()
      .setDurationValueMinutes(habit.durationCompleted % 60);

  if (Platform.isAndroid) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, mystate) {
              return AlertDialog(
                content: AndroidCompleteHistoricalHabitWidget(
                  habit: habit,
                  amountCheck: amountCheck,
                ),
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
                                      .applyAmountCompleted(index, context);
                                }
                                context
                                    .read<HistoricalHabitProvider>()
                                    .applyHistoricalAmountCompleted(
                                        habit, context, time, index);
                              } else {
                                if (isToday) {
                                  context
                                      .read<HabitProvider>()
                                      .applyDurationCompleted(index, context);
                                }
                                context
                                    .read<HistoricalHabitProvider>()
                                    .applyHistoricalDurationCompleted(
                                        habit, context, time, index);
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
              return CupertinoAlertDialog(
                content: CupertinoCompleteHistoricalHabitWidget(
                  habit: habit,
                  amountCheck: amountCheck,
                ),
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
                                .applyAmountCompleted(index, context);
                          }
                          context
                              .read<HistoricalHabitProvider>()
                              .applyHistoricalAmountCompleted(
                                  habit, context, time, index);
                        } else {
                          if (isToday) {
                            context
                                .read<HabitProvider>()
                                .applyDurationCompleted(index, context);
                          }
                          context
                              .read<HistoricalHabitProvider>()
                              .applyHistoricalDurationCompleted(
                                  habit, context, time, index);
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
