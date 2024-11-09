import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/main.dart';
import 'package:habitt/pages/habit/add_habit_page.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/habit/checkForTasks.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:provider/provider.dart';

late HabitData myHabit;

Future<void> createNewHabit(createcontroller, BuildContext context) async {
  int currentDurationValue = Provider.of<HabitProvider>(context, listen: false)
          .durationMinutes +
      (Provider.of<HabitProvider>(context, listen: false).durationHours * 60);

  List habitNotifications =
      Provider.of<HabitProvider>(context, listen: false).habitNotifications;

  myHabit = HabitData(
      name: createcontroller.text,
      completed: false,
      icon: getIconString(
          Provider.of<HabitProvider>(context, listen: false).updatedIcon.icon),
      category:
          Provider.of<HabitProvider>(context, listen: false).dropDownValue,
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
      notes: Provider.of<HabitProvider>(context, listen: false)
          .notescontroller
          .text,
      longestStreak: 0,
      id: streakBox.get('highestId')! + 1,
      task: Provider.of<HabitProvider>(context, listen: false).additionalTask);
  await habitBox.add(myHabit);
  streakBox.put('highestId', streakBox.get('highestId')! + 1);
  hasHabits();
  saveHabitsForToday();
  // Updates the main category height if new habit category is same as the main category
  if (context.mounted) {
    checkForTasks(context);
    if (Provider.of<HabitProvider>(context, listen: false).dropDownValue ==
        context.watch<HabitProvider>().mainCategory) {
      Provider.of<HabitProvider>(context, listen: false)
          .updateMainCategoryHeight();
    }
  }

  createcontroller.clear();

  habitNotifications = [];

  //showPopup(context, "Habit added!");
}
