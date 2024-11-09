import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:provider/provider.dart';

void checkForTasks(BuildContext context) {
  if (Provider.of<HabitProvider>(context, listen: false).additionalTask) {
    Provider.of<DataProvider>(context, listen: false).hasTasks = true;
  } else {
    for (var habit in habitBox.values) {
      if (habit.task) {
        Provider.of<DataProvider>(context, listen: false).hasTasks = true;
        break;
      } else {
        Provider.of<DataProvider>(context, listen: false).hasTasks = false;
      }
    }
  }
}
