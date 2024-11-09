import 'package:flutter/material.dart';
import 'package:habitt/main.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/habit/checkForTasks.dart';
import 'package:provider/provider.dart';

late String category;

Future<void> deleteHabit(int index, context, editcontroller) async {
  category = habitBox.getAt(index)!.category.toString();
  int categoryHabits = 0;

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)?.category == category) {
      categoryHabits += 1;
    }
  }
  if (categoryHabits == 1) {
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

  habitBox.deleteAt(index);
  checkForTasks(context);

  deleted = true;
  editcontroller.text = "";
  Navigator.of(context).pop();

  Provider.of<HabitProvider>(context, listen: false).habitGoalValue = 0;
  updated = false;
  editcontroller.clear();
  changed = false;
  Provider.of<HabitProvider>(context, listen: false).updatedIcon = startIcon;
}
