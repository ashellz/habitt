import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/main.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

var habitListLenght = Hive.box<HabitData>('habits').length;

late String editedFrom;
late String editedTo;

void editHabit(int index, BuildContext context, editcontroller) {
  editedFrom = habitBox.getAt(index)!.category;
  editedTo = Provider.of<HabitProvider>(context, listen: false).dropDownValue;

  int duration = Provider.of<HabitProvider>(context, listen: false)
          .durationMinutes +
      (Provider.of<HabitProvider>(context, listen: false).durationHours * 60);

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

  bool resetCompleted = false;

  if (habitBox.getAt(index)!.amount !=
      Provider.of<HabitProvider>(context, listen: false).amount) {
    resetCompleted = true;
  } else if (habitBox.getAt(index)!.duration != duration) {
    resetCompleted = true;
  }

  if (editedFrom != editedTo) {
    String mainCategory =
        Provider.of<HabitProvider>(context, listen: false).mainCategory;

    if (editedFrom == mainCategory || editedTo == mainCategory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HabitProvider>().chooseMainCategory();
        context.read<HabitProvider>().updateMainCategoryHeight();
      });
    }
  }

  var editHabitNotifications =
      Provider.of<HabitProvider>(context, listen: false).habitNotifications;

  habitBox.putAt(
      index,
      HabitData(
        name: editcontroller.text,
        completed: resetCompleted ? false : habitBox.getAt(index)!.completed,
        icon: getIconString(Provider.of<HabitProvider>(context, listen: false)
            .updatedIcon
            .icon),
        category:
            Provider.of<HabitProvider>(context, listen: false).dropDownValue,
        streak: habitBox.getAt(index)?.streak ?? 0,
        amount:
            Provider.of<HabitProvider>(context, listen: false).habitGoalValue ==
                    1
                ? Provider.of<HabitProvider>(context, listen: false).amount
                : habitBox.getAt(index)!.amount,
        amountName: Provider.of<HabitProvider>(context, listen: false)
            .habitGoalController
            .text,
        amountCompleted:
            resetCompleted ? 0 : habitBox.getAt(index)!.amountCompleted,
        duration:
            Provider.of<HabitProvider>(context, listen: false).habitGoalValue ==
                    2
                ? duration
                : habitBox.getAt(index)?.duration ?? 0,
        durationCompleted:
            resetCompleted ? 0 : habitBox.getAt(index)!.durationCompleted,
        skipped: resetCompleted ? false : habitBox.getAt(index)!.skipped,
        tag: habitTag,
        notifications: editHabitNotifications,
        notes: Provider.of<HabitProvider>(context, listen: false)
            .notescontroller
            .text,
        longestStreak: habitBox.getAt(index)!.longestStreak,
        id: habitBox.getAt(index)!.id,
        task: Provider.of<HabitProvider>(context, listen: false).additionalTask,
      ));

  Provider.of<HabitProvider>(context, listen: false).dropDownValue = 'Any time';
  if (context.mounted) {
    Provider.of<HabitProvider>(context, listen: false).notescontroller.clear();
  }

  openCategory(context);

  // showPopup(context, "Habit edited!");
}

void openCategory(BuildContext context) {
  var dropDownValue =
      Provider.of<HabitProvider>(context, listen: false).dropDownValue;

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
