import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_data.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/Add%20Habit%20Page/add_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:habit_tracker/util/functions/habit/saveHabits.dart';
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
  );
  await habitBox.add(myHabit);
  hasHabits();
  saveHabitsForToday();
  // Updates the main category height if new habit category is same as the main category
  if (context.mounted) {
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
