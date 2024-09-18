import 'package:flutter/material.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/checkCategory.dart';
import 'package:provider/provider.dart';

late String category;

Future<void> deleteHabit(int index, context, editcontroller) async {
  category = checkCategory(habitBox.getAt(index)!.category.toString());
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

  deleted = true;
  editcontroller.text = "";
  Navigator.of(context).pop();

  habitGoalEdit = 0;
  updated = false;
  editcontroller.clear();
  changed = false;
  Provider.of<HabitProvider>(context, listen: false).updatedIcon = startIcon;
}
