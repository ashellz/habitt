import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habit_tracker/pages/habit/notifications_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

var habitListLenght = Hive.box<HabitData>('habits').length;

late String editedFrom;
late String editedTo;

void editHabit(int index, BuildContext context, editcontroller) {
  editedFrom = habitBox.getAt(index)!.category;
  editedTo = dropDownValue;

  duration = durationMinutes + (durationHours * 60);

  int categoryHabits = 0;
  String category = editedFrom;

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)?.category == category) {
      categoryHabits += 1;
    }
  }
  if (categoryHabits < 2) {
    if (category == "Morning") {
      morningHasHabits = false;
    } else if (category == "Afternoon") {
      afternoonHasHabits = false;
    } else if (category == "Evening") {
      eveningHasHabits = false;
    } else if (category == "Any time") {
      anytimeHasHabits = false;
    }
  }

  habitBox.putAt(
      index,
      HabitData(
        name: editcontroller.text,
        completed: false,
        icon: getIconString(updatedIcon.icon),
        category: dropDownValue,
        streak: habitBox.getAt(index)?.streak ?? 0,
        amount: habitGoalEdit == 1 ? amount : habitBox.getAt(index)!.amount,
        amountName: amountNameControllerEdit.text,
        amountCompleted: 0,
        duration: habitGoalEdit == 2
            ? duration
            : habitBox.getAt(index)?.duration ?? 0,
        durationCompleted: 0,
        skipped: false,
        tag: habitTag,
        notifications: editHabitNotifications,
        notes: Provider.of<HabitProvider>(context, listen: false)
            .notescontroller
            .text,
        longestStreak: habitBox.getAt(index)!.longestStreak,
      ));

  dropDownValue = 'Any time';
  if (context.mounted) {
    Provider.of<HabitProvider>(context, listen: false).notescontroller.clear();
  }
  if (editedFrom != editedTo) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().updateMainCategoryHeight();
    });
  }

  openCategory("edited");
  // showPopup(context, "Habit edited!");
}

void openCategory(String key) {
  if (dropDownValue == "Morning") {
    if (morningHasHabits == false) {
      morningHasHabits = true;
    }
  } else if (dropDownValue == "Afternoon") {
    if (afternoonHasHabits == false) {
      afternoonHasHabits = true;
    }
  } else if (dropDownValue == "Evening") {
    if (eveningHasHabits == false) {
      eveningHasHabits = true;
    }
  } else if (dropDownValue == "Any time") {
    if (anytimeHasHabits == false) {
      anytimeHasHabits = true;
    }
  }
}
