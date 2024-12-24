import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/habit/add_habit_page.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:habitt/util/objects/popup_notification.dart';
import 'package:provider/provider.dart';

late HabitData myHabit;

Future<void> createNewHabit(createcontroller, BuildContext context) async {
  int currentDurationValue = Provider.of<HabitProvider>(context, listen: false)
          .durationMinutes +
      (Provider.of<HabitProvider>(context, listen: false).durationHours * 60);

  List habitNotifications =
      Provider.of<HabitProvider>(context, listen: false).habitNotifications;

  String habitType = Provider.of<DataProvider>(context, listen: false)
      .habitTypeController
      .text;

  if (habitType == AppLocale.daily.getString(context)) {
    habitType = "Daily";
  } else if (habitType == AppLocale.weekly.getString(context)) {
    habitType = "Weekly";
  } else if (habitType == AppLocale.monthly.getString(context)) {
    habitType = "Monthly";
  } else if (habitType == AppLocale.custom.getString(context)) {
    habitType = "Custom";
  }

  List<DateTime> customAppearance = [];

  if (habitType == "Custom") {
    int counter = 0;
    DateTime day = DateTime.now();

    for (int i = 0; i < 30; i++) {
      if (counter %
              Provider.of<DataProvider>(context, listen: false)
                  .customValueSelected ==
          0) {
        customAppearance.add(day);
      }
      day = day.add(const Duration(days: 1));
      counter++;
    }
  }

  myHabit = HabitData(
    name: createcontroller.text,
    completed: false,
    icon: getStringFromIconDataIcon(
        Provider.of<HabitProvider>(context, listen: false).updatedIcon.icon),
    category: Provider.of<HabitProvider>(context, listen: false).dropDownValue,
    streak: 0,
    amount:
        Provider.of<HabitProvider>(context, listen: false).habitGoalValue == 1
            ? Provider.of<HabitProvider>(context, listen: false).amount
            : 1,
    amountName: amountNameController.text,
    amountCompleted: 0,
    duration:
        Provider.of<HabitProvider>(context, listen: false).habitGoalValue == 2
            ? currentDurationValue
            : 0,
    durationCompleted: 0,
    skipped: false,
    tag: habitTag,
    notifications: habitNotifications,
    notes:
        Provider.of<HabitProvider>(context, listen: false).notescontroller.text,
    longestStreak: 0,
    id: streakBox.get('highestId')! + 1,
    task: Provider.of<HabitProvider>(context, listen: false).additionalTask,
    type: habitType,
    weekValue:
        Provider.of<DataProvider>(context, listen: false).weekValueSelected,
    monthValue:
        Provider.of<DataProvider>(context, listen: false).monthValueSelected,
    customValue:
        Provider.of<DataProvider>(context, listen: false).customValueSelected,
    selectedDaysAWeek:
        Provider.of<DataProvider>(context, listen: false).selectedDaysAWeek,
    selectedDaysAMonth:
        Provider.of<DataProvider>(context, listen: false).selectedDaysAMonth,
    customAppearance: customAppearance,
    timesCompletedThisWeek: 0,
    timesCompletedThisMonth: 0,
    paused: false,
    lastCustomUpdate: DateTime.now(),
  );
  await habitBox.add(myHabit);
  streakBox.put('highestId', streakBox.get('highestId')! + 1);

  if (context.mounted) {
    for (var habit
        in Provider.of<DataProvider>(context, listen: false).habitsList) {
      if (habit.id == 1) {
        habit.completed = true;
        habit.save();
      }
    }

    saveHabitsForToday(context);
    context.read<DataProvider>().updateHabits(context);
    Provider.of<DataProvider>(context, listen: false).updateAllHabits();
    NotificationManager()
        .showNotification(context, AppLocale.habitAdded.getString(context));
  }

  createcontroller.clear();
  habitNotifications = [];
}
