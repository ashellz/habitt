import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/allhabits_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
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

  bool isTaskBefore = habitBox.getAt(index)!.task;
  bool isTaskAfter =
      Provider.of<HabitProvider>(context, listen: false).additionalTask;

  if (isTaskBefore) {
    if (!isTaskAfter) {
      context.read<AllHabitsProvider>().initAllHabitsPage(context);
      context.read<AllHabitsProvider>().setAllHabitsTagSelected("Categories");
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
        context.read<HabitProvider>().chooseMainCategory(context);
        context.read<HabitProvider>().updateMainCategoryHeight(context);
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
              Provider.of<HabitProvider>(context, listen: false).habitGoalValue == 1
                  ? Provider.of<HabitProvider>(context, listen: false).amount
                  : habitBox.getAt(index)!.amount,
          amountName: Provider.of<HabitProvider>(context, listen: false)
              .habitGoalController
              .text,
          amountCompleted:
              resetCompleted ? 0 : habitBox.getAt(index)!.amountCompleted,
          duration:
              Provider.of<HabitProvider>(context, listen: false).habitGoalValue == 2
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
          task:
              Provider.of<HabitProvider>(context, listen: false).additionalTask,
          type: Provider.of<DataProvider>(context, listen: false)
              .habitTypeController
              .text,
          weekValue: Provider.of<DataProvider>(context, listen: false)
              .weekValueSelected,
          monthValue: Provider.of<DataProvider>(context, listen: false)
              .monthValueSelected,
          customValue: Provider.of<DataProvider>(context, listen: false).customValueSelected,
          selectedDaysAWeek: Provider.of<DataProvider>(context, listen: false).selectedDaysAWeek,
          selectedDaysAMonth: Provider.of<DataProvider>(context, listen: false).selectedDaysAMonth,
          daysUntilAppearance: habitBox.getAt(index)!.daysUntilAppearance,
          timesCompletedThisWeek: habitBox.getAt(index)!.timesCompletedThisWeek,
          timesCompletedThisMonth: habitBox.getAt(index)!.timesCompletedThisMonth,
          paused: habitBox.getAt(index)!.paused));

  Provider.of<HabitProvider>(context, listen: false).dropDownValue = 'Any time';
  if (context.mounted) {
    context.read<DataProvider>().updateHabits(context);
    context.read<DataProvider>().updateAllHabits();
    Provider.of<HabitProvider>(context, listen: false).notescontroller.clear();
  }

  // showPopup(context, "Habit edited!");
}
