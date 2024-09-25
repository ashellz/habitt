// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:provider/provider.dart';

void buildEditedValues(
    BuildContext context,
    int index,
    TextEditingController editcontroller,
    double? lowestCompletionRate,
    List<double> completionRates,
    double? highestCompletionRate) {
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

    var historicalList = historicalBox.values.toList();

    historicalList.sort((b, a) {
      DateTime dateA = a.date;
      DateTime dateB = b.date;
      return dateA.compareTo(dateB);
    });

    completionRates.clear();
    highestCompletionRate = 0;
    lowestCompletionRate = 100;

    for (int i = 0; i < historicalList.length; i++) {
      int habitsCompleted = 0;
      int totalHabits = 0;

      if (kDebugMode) {
        print("HISTORICAL LIST: ${historicalList[i].date}");
      }
      for (int j = 0; j < historicalList.length; j++) {
        if (j + i < historicalList.length) {
          if (kDebugMode) {
            print("HISTORICAL LIST MINUS: ${historicalList[j + i].date}");
          }

          if (historicalList[j + i].data[index].completed) {
            if (!historicalList[j + i].data[index].skipped) {
              habitsCompleted++;
            }
          }
          totalHabits++;
        }
      }
      double completionRate = (habitsCompleted / totalHabits) * 100;

      if (completionRate > highestCompletionRate!) {
        highestCompletionRate = completionRate;
      }
      if (completionRate < lowestCompletionRate!) {
        lowestCompletionRate = completionRate;
      }

      completionRates.add(completionRate);
    }

    /*
    for (int i = 0; i < historicalList.length; i++) {
      if (historicalList.length - 1 - i < 0) {
        break;
      }

      int habitsCompleted = 0;
      int totalHabits = 0;

      for (int j = 0; j < 30; j++) {
        if (historicalList.length - 1 - i - j < 0) {
          break;
        }
        if (historicalList[historicalList.length - 1 - i - j].data.length <=
            index) {
          break;
        }

        // goes back 30 days from the original habit to calculate completion rate
        if (historicalList[historicalList.length - 1 - i - j]
            .data[index]
            .completed) {
          if (!historicalList[historicalList.length - 1 - i - j]
              .data[index]
              .skipped) {
            habitsCompleted++;
          }
        }
        totalHabits++;
      }
      double completionRate = (habitsCompleted / totalHabits) * 100;

      if (completionRate > highestCompletionRate!) {
        highestCompletionRate = completionRate;
      }
      if (completionRate < lowestCompletionRate!) {
        lowestCompletionRate = completionRate;
      }

      completionRates.add(completionRate);
    }*/

    updated = true;
  }
}
