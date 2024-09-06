import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/add_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:provider/provider.dart';

late HabitData myHabit;

Future<void> createNewHabit(createcontroller, BuildContext context) async {
  currentDurationValue =
      currentDurationValueMinutes + (currentDurationValueHours * 60);

  List habitNotifications =
      Provider.of<HabitProvider>(context, listen: false).habitNotifications;

  myHabit = HabitData(
    name: createcontroller.text,
    completed: false,
    icon: getIconString(updatedIcon.icon),
    category: dropDownValue,
    streak: 0,
    amount: habitGoal == 1 ? currentAmountValue : 1,
    amountName: amountNameController.text,
    amountCompleted: 0,
    duration: habitGoal == 2 ? currentDurationValue : 0,
    durationCompleted: 0,
    skipped: false,
    tag: habitTag,
    notifications: habitNotifications,
    notes:
        Provider.of<HabitProvider>(context, listen: false).notescontroller.text,
  );
  await habitBox.add(myHabit);
  hasHabits();

  // Updates the main category height if new habit category is same as the main category
  if (dropDownValue == context.watch<HabitProvider>().mainCategory) {
    if (context.mounted) {
      context.read<HabitProvider>().updateMainCategoryHeight();
    }
  }

  createcontroller.clear();

  habitNotifications = [];

  //showPopup(context, "Habit added!");
}
