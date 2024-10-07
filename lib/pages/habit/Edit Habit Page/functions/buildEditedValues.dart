// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/functions/buildCompletionRateGraph.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:provider/provider.dart';

void buildEditedValues(
    BuildContext context,
    int index,
    TextEditingController editcontroller,
    double? lowestCompletionRate,
    List<double> completionRates,
    double? highestCompletionRate,
    List<int> everyFifthDay,
    List<int> everyFifthMonth) {
  var habitProvider = Provider.of<HabitProvider>(context, listen: false);

  if (!changed) {
    habitProvider.updatedIcon = Icon(getIcon(index));
  }

  if (!updated) {
    int amount = habitProvider.amount;
    int duration = habitProvider.duration;
    int durationHours = habitProvider.durationHours;
    int durationMinutes = habitProvider.durationMinutes;

    habitProvider.categoriesExpanded = false;
    if (habitBox.getAt(index)!.amount > 1) {
      habitProvider.habitGoalValue = 1;
      habitProvider.amount = habitBox.getAt(index)!.amount;
      habitProvider.habitGoalController.text =
          habitBox.getAt(index)!.amountName;
      habitProvider.duration = 0;
      habitProvider.durationHours = 0;
      habitProvider.durationMinutes = 0;
    } else if (habitBox.getAt(index)!.duration > 0) {
      habitProvider.habitGoalValue = 2;
      habitProvider.duration = habitBox.getAt(index)!.duration;
      habitProvider.amount = 1;
      habitProvider.durationHours = duration ~/ 60;
      habitProvider.durationMinutes = duration % 60;
    } else {
      habitProvider.habitGoalValue = 0;
      habitProvider.amount = 1;
      habitProvider.duration = 0;
      habitProvider.durationHours = 0;
      habitProvider.durationMinutes = 0;
    }

    if (editcontroller.text.isEmpty) {
      editcontroller.text = habitBox.getAt(index)!.name;
    }

    if (habitProvider.habitGoalController.text.isEmpty) {
      habitProvider.habitGoalController.text = "times";
    }

    habitTag = habitBox.getAt(index)!.tag;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<HabitProvider>()
          .changeNotification(List.from(habitBox.getAt(index)!.notifications));
      context
          .read<HabitProvider>()
          .updateDropDownValue(habitBox.getAt(index)!.category);
    });

    habitProvider.notescontroller.text = habitBox.getAt(index)!.notes;

    buildCompletionRateGraph(index, completionRates, highestCompletionRate,
        lowestCompletionRate, everyFifthDay, everyFifthMonth);

    updated = true;
  }
}
