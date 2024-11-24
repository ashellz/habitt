import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:habitt/util/objects/habit/Complete%20Habit%20Dialog/android_complete_dialog.dart';
import 'package:habitt/util/objects/habit/Complete%20Habit%20Dialog/cupertino_complete_dialog.dart';
import 'package:provider/provider.dart';

completeHabitDialog(
  int index,
  bool isAdLoaded,
  interstitialAd,
  BuildContext context,
) {
  bool amountCheck = false;

  if (habitBox.getAt(index)!.amount > 1) amountCheck = true;

  context
      .read<DataProvider>()
      .setAmountValue(habitBox.getAt(index)!.amountCompleted);
  context
      .read<DataProvider>()
      .setDurationValueHours(habitBox.getAt(index)!.durationCompleted ~/ 60);
  context
      .read<DataProvider>()
      .setDurationValueMinutes(habitBox.getAt(index)!.durationCompleted % 60);

  if (Platform.isAndroid) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, mystate) {
              return AlertDialog(
                content: AndroidCompleteHabitWidget(
                  index: index,
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
                            context.read<HabitProvider>().completeHabitProvider(
                                index, isAdLoaded, interstitialAd, context);
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
                                    .applyAmountCompleted(index, context);
                              } else {
                                context
                                    .read<HabitProvider>()
                                    .applyDurationCompleted(index, context);
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
              return CupertinoAlertDialog(
                content: CupertinoCompleteHabitWidget(
                  index: index,
                  amountCheck: amountCheck,
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(AppLocale.done.getString(context)),
                    onPressed: () {
                      context.read<HabitProvider>().completeHabitProvider(
                          index, isAdLoaded, interstitialAd, context);
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
                              .applyAmountCompleted(index, context);
                        } else {
                          context
                              .read<HabitProvider>()
                              .applyDurationCompleted(index, context);
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
