// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/functions/buildCompletionRateGraph.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:provider/provider.dart';

void buildEditedValues(
    BuildContext context,
    int id,
    TextEditingController editcontroller,
    double? lowestCompletionRate,
    List<double> completionRates,
    double? highestCompletionRate,
    List<int> everyFifthDay,
    List<int> everyFifthMonth) {
  var habitProvider = Provider.of<HabitProvider>(context, listen: false);
  var habit = context.read<HabitProvider>().getHabitAt(id);

  if (!changed) {
    habitProvider.updatedIcon = Icon(getIcon(habitProvider.getIndexFromId(id)));
  }

  if (!updated) {
    int amount = habitProvider.amount;
    int duration = habitProvider.duration;
    int durationHours = habitProvider.durationHours;
    int durationMinutes = habitProvider.durationMinutes;

    habitProvider.categoriesExpanded = false;
    if (habit.amount > 1) {
      habitProvider.habitGoalValue = 1;
      habitProvider.amount = habit.amount;
      habitProvider.habitGoalController.text = habit.amountName;
      habitProvider.duration = 0;
      habitProvider.durationHours = 0;
      habitProvider.durationMinutes = 0;
    } else if (habit.duration > 0) {
      habitProvider.habitGoalValue = 2;
      habitProvider.duration = habit.duration;
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
      editcontroller.text = habit.name;
    }

    if (habitProvider.habitGoalController.text.isEmpty) {
      habitProvider.habitGoalController.text = "times";
    }

    habitTag = habit.tag;

    Provider.of<HabitProvider>(context, listen: false).additionalTask =
        habit.task;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<HabitProvider>()
          .changeNotification(List.from(habit.notifications));
      context.read<HabitProvider>().updateDropDownValue(habit.category);
      context.read<DataProvider>().updateHabitType(habit.type);
      context.read<DataProvider>().setCustomValueSelected(habit.customValue);
      context.read<DataProvider>().setMonthValueSelected(habit.monthValue);
      context.read<DataProvider>().setWeekValueSelected(habit.weekValue);
      context.read<DataProvider>().selectDaysAWeek(habit.selectedDaysAWeek);
      context.read<DataProvider>().selectDaysAMonth(habit.selectedDaysAMonth);
    });

    habitProvider.notescontroller.text = habit.notes;

    buildCompletionRateGraph(id, completionRates, highestCompletionRate,
        lowestCompletionRate, everyFifthDay, everyFifthMonth);

    updated = true;
  }
}
