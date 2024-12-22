import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/allhabits_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:habitt/util/objects/popup_notification.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

var habitListLenght = Hive.box<HabitData>('habits').length;

late String editedFrom;
late String editedTo;

void editHabit(int index, BuildContext context, editcontroller) {
  editedFrom = habitBox.getAt(index)!.category;
  editedTo = Provider.of<HabitProvider>(context, listen: false).dropDownValue;

  int duration = Provider.of<HabitProvider>(context, listen: false)
          .durationMinutes +
      (Provider.of<HabitProvider>(context, listen: false).durationHours * 60);

  bool isTaskBefore = habitBox.getAt(index)!.task;
  bool isTaskAfter =
      Provider.of<HabitProvider>(context, listen: false).additionalTask;

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

  if (isTaskBefore) {
    if (!isTaskAfter) {
      context.read<AllHabitsProvider>().initAllHabitsPage(context);
      context.read<AllHabitsProvider>().setAllHabitsTagSelected("Categories");
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  bool resetCompleted = false;

  if (habitBox.getAt(index)!.amount !=
      Provider.of<HabitProvider>(context, listen: false).amount) {
    resetCompleted = true;
  } else if (habitBox.getAt(index)!.duration != duration) {
    resetCompleted = true;
  }

  var editHabitNotifications =
      Provider.of<HabitProvider>(context, listen: false).habitNotifications;

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

  habitBox.putAt(
      index,
      HabitData(
          name: editcontroller.text,
          completed: resetCompleted ? false : habitBox.getAt(index)!.completed,
          icon: getIconString(Provider.of<HabitProvider>(context, listen: false)
              .updatedIcon
              .icon),
          category:
              Provider.of<HabitProvider>(context, listen: false).dropDownValue,
          streak: habitBox.getAt(index)?.streak ?? 0,
          amount: Provider.of<HabitProvider>(context, listen: false).habitGoalValue == 1
              ? Provider.of<HabitProvider>(context, listen: false).amount
              : habitBox.getAt(index)!.amount,
          amountName: Provider.of<HabitProvider>(context, listen: false)
              .habitGoalController
              .text,
          amountCompleted:
              resetCompleted ? 0 : habitBox.getAt(index)!.amountCompleted,
          duration: Provider.of<HabitProvider>(context, listen: false).habitGoalValue == 2
              ? duration
              : habitBox.getAt(index)?.duration ?? 0,
          durationCompleted:
              resetCompleted ? 0 : habitBox.getAt(index)!.durationCompleted,
          skipped: resetCompleted ? false : habitBox.getAt(index)!.skipped,
          tag: habitTag,
          notifications: editHabitNotifications,
          notes: Provider.of<HabitProvider>(context, listen: false)
              .notescontroller
              .text,
          longestStreak: habitBox.getAt(index)!.longestStreak,
          id: habitBox.getAt(index)!.id,
          task:
              Provider.of<HabitProvider>(context, listen: false).additionalTask,
          type: habitType,
          weekValue: Provider.of<DataProvider>(context, listen: false)
              .weekValueSelected,
          monthValue: Provider.of<DataProvider>(context, listen: false)
              .monthValueSelected,
          customValue: Provider.of<DataProvider>(context, listen: false)
              .customValueSelected,
          selectedDaysAWeek:
              Provider.of<DataProvider>(context, listen: false).selectedDaysAWeek,
          selectedDaysAMonth: Provider.of<DataProvider>(context, listen: false).selectedDaysAMonth,
          customAppearance: customAppearance,
          timesCompletedThisWeek: habitBox.getAt(index)!.timesCompletedThisWeek,
          timesCompletedThisMonth: habitBox.getAt(index)!.timesCompletedThisMonth,
          paused: habitBox.getAt(index)!.paused));

  Provider.of<HabitProvider>(context, listen: false).dropDownValue = 'Any time';
  saveHabitsForToday(context);
  if (context.mounted) {
    context.read<DataProvider>().updateHabits(context);
    context.read<DataProvider>().updateAllHabits();
    Provider.of<HabitProvider>(context, listen: false).notescontroller.clear();
    NotificationManager()
        .showNotification(context, AppLocale.habitEdited.getString(context));
  }
}
