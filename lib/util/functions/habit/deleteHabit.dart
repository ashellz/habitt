import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/allhabits_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:habitt/util/objects/popup_notification.dart';
import 'package:provider/provider.dart';

late String category;

Future<void> deleteHabit(int index, context, editcontroller) async {
  category = habitBox.getAt(index)!.category.toString();

  habitBox.deleteAt(index);

  Provider.of<DataProvider>(context, listen: false).updateHabits(context);
  Provider.of<DataProvider>(context, listen: false).updateAllHabits();
  Provider.of<AllHabitsProvider>(context, listen: false)
      .setAllHabitsTagSelected("Categories");
  Provider.of<AllHabitsProvider>(context, listen: false)
      .initAllHabitsPage(context);
  NotificationManager()
      .showNotification(context, AppLocale.habitDeleted.getString(context));

  deleted = true;
  editcontroller.text = "";
  Navigator.of(context).pop();

  Provider.of<HabitProvider>(context, listen: false).habitGoalValue = 0;
  updated = false;
  editcontroller.clear();
  changed = false;
  Provider.of<HabitProvider>(context, listen: false).updatedIcon = startIcon;
  saveHabitsForToday(context);
}
