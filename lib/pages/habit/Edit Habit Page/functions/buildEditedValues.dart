// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:provider/provider.dart';

void buildEditedValues(
    BuildContext context, int index, TextEditingController editcontroller) {
  if (!changed) {
    context.watch<HabitProvider>().updatedIcon = Icon(getIcon(index));
  }

  if (!updated) {
    int amount = Provider.of<HabitProvider>(context, listen: false).amount;
    int duration = Provider.of<HabitProvider>(context, listen: false).duration;
    int durationHours =
        Provider.of<HabitProvider>(context, listen: false).durationHours;
    int durationMinutes =
        Provider.of<HabitProvider>(context, listen: false).durationMinutes;

    context.watch<HabitProvider>().categoriesExpanded = false;
    if (habitBox.getAt(index)!.amount > 1) {
      habitGoalEdit = 1;
      amount = habitBox.getAt(index)!.amount;
      Provider.of<HabitProvider>(context, listen: false)
          .habitGoalController
          .text = habitBox.getAt(index)!.amountName;
      duration = 0;
      durationHours = 0;
      durationMinutes = 0;
    } else if (habitBox.getAt(index)!.duration > 0) {
      habitGoalEdit = 2;
      duration = habitBox.getAt(index)!.duration;
      amount = 1;
      durationHours = duration ~/ 60;
      durationMinutes = duration % 60;
    } else {
      habitGoalEdit = 0;
      amount = 1;
      duration = 0;
      durationHours = 0;
      durationMinutes = 0;
    }

    if (editcontroller.text.isEmpty) {
      editcontroller.text = habitBox.getAt(index)!.name;
    }

    if (Provider.of<HabitProvider>(context, listen: false)
        .habitGoalController
        .text
        .isEmpty) {
      Provider.of<HabitProvider>(context, listen: false)
          .habitGoalController
          .text = "times";
    }

    habitTag = habitBox.getAt(index)!.tag;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<HabitProvider>()
          .changeNotification(List.from(habitBox.getAt(index)!.notifications));
    });

    context.watch<HabitProvider>().notescontroller.text =
        habitBox.getAt(index)!.notes;

    context
        .read<HabitProvider>()
        .updateDropDownValue(habitBox.getAt(index)!.category);

    updated = true;
  }
}
