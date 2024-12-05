import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

bool categoryCompleted(String category, BuildContext context) {
  // does count tasks as well
  int habits = 0;
  int completedHabits = 0;

  List<HabitData> habitsList = context.watch<DataProvider>().habitsList;
  int habitsListLength = habitsList.length;

  List<String> realCategories = ["Any time", "Morning", "Afternoon", "Evening"];

  if (category == "All") {
    return allHabitsCompleted(context);
  }

  if (!realCategories.contains(category)) {
    return tagCompleted(category, context);
  }

  for (int i = 0; i < habitsListLength; i++) {
    if (habitsList[i].category == category) {
      habits++;

      if (habitsList[i].completed == true) {
        completedHabits++;
      }
    }
  }

  if (completedHabits == habits) {
    return true;
  } else {
    return false;
  }
}

bool tagCompleted(String tag, BuildContext context) {
  List<HabitData> habitsList = context.watch<DataProvider>().habitsList;
  int habitsListLength = habitsList.length;
  int habits = 0;
  int completedHabits = 0;

  for (int i = 0; i < habitsListLength; i++) {
    if (habitsList[i].tag == tag) {
      habits++;

      if (habitsList[i].completed == true) {
        completedHabits++;
      }
    }
  }

  if (completedHabits == habits) {
    return true;
  } else {
    return false;
  }
}

bool allHabitsCompleted(BuildContext context) {
  List<HabitData> habitsList =
      Provider.of<DataProvider>(context, listen: false).habitsList;
  for (var habit in habitsList) {
    if (!habit.completed) {
      return false;
    }
  }
  return true;
}
