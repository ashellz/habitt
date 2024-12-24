import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/menu/Calendar%20Page/widgets/category_widgets.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:provider/provider.dart';

otherCategoriesListCalendar(
    BuildContext context, chosenDay, bool isAdLoaded, interstitialAd) {
  late int boxIndex = 0;
  List<int> todayDate = [chosenDay.year, chosenDay.month, chosenDay.day];
  bool todayExists = false;

  for (int i = 0; i < historicalBox.length; i++) {
    List<int> date = [
      historicalBox.getAt(i)!.date.year,
      historicalBox.getAt(i)!.date.month,
      historicalBox.getAt(i)!.date.day
    ];

    if (const ListEquality().equals(date, todayDate)) {
      todayExists = true;
      boxIndex = i;
      break;
    }
  }

  void saveTodayHabits() {
    List<HistoricalHabitData> todayHabitsList = [];

    List<HabitData> getSelectedDayHabits(BuildContext context, chosenDay) {
      List<HabitData> habitsList = [];

      for (var habit in habitBox.values) {
        if (!habit.paused) {
          if (habit.type == "Daily") {
            habitsList.add(habit);
          } else if (habit.type == "Weekly") {
            if (habit.selectedDaysAWeek.isEmpty) {
              if (habit.timesCompletedThisWeek < habit.weekValue) {
                habitsList.add(habit);
              }
            } else {
              if (habit.selectedDaysAWeek.contains(chosenDay.weekday)) {
                habitsList.add(habit);
              }
            }
          } else if (habit.type == "Monthly") {
            if (habit.selectedDaysAMonth.isEmpty) {
              if (habit.timesCompletedThisMonth < habit.monthValue) {
                habitsList.add(habit);
              }
            } else {
              if (habit.selectedDaysAMonth.contains(chosenDay.day)) {
                habitsList.add(habit);
              }
            }
          } else if (habit.type == "Custom") {
            List<List<int>> days = [];
            for (int i = 0; i < habit.customAppearance.length; i++) {
              List<int> day = [
                habit.customAppearance[i].year,
                habit.customAppearance[i].month,
                habit.customAppearance[i].day
              ];
              days.add(day);
            }

            for (var day in days) {
              if (day[0] == chosenDay.year &&
                  day[1] == chosenDay.month &&
                  day[2] == chosenDay.day) {
                habitsList.add(habit);
                break;
              }
            }
          }
        }
      }

      return habitsList;
    }

    List<HabitData> habitsList = getSelectedDayHabits(context, chosenDay);

    for (var habit in habitsList) {
      HistoricalHabitData newHistoricalHabit = HistoricalHabitData(
          name: habit.name,
          category: habit.category,
          completed: false,
          icon: habit.icon,
          amount: habit.amount,
          amountCompleted: 0,
          amountName: habit.amountName,
          duration: habit.duration,
          durationCompleted: 0,
          skipped: false,
          id: habit.id,
          task: habit.task,
          type: habit.type,
          weekValue: habit.weekValue,
          monthValue: habit.monthValue,
          customValue: habit.customValue,
          selectedDaysAWeek: habit.selectedDaysAWeek,
          selectedDaysAMonth: habit.selectedDaysAMonth);

      todayHabitsList.add(newHistoricalHabit);
    }

    historicalBox.add(HistoricalHabit(
        date: chosenDay, data: todayHabitsList, addedHabits: []));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoricalHabitProvider>().updateHistoricalHabits(chosenDay);
    });

    boxIndex = historicalBox.length - 1;
  }

  if (Provider.of<HistoricalHabitProvider>(context, listen: false)
          .historicalHabits
          .isEmpty ||
      !todayExists) {
    DateTime dayJoined = metadataBox.get('dayJoined')!;

    if (dayJoined.isBefore(chosenDay)) {
      if (chosenDay.year <= DateTime.now().year) {
        // if the year is equal or less than the current year
        if (chosenDay.year == DateTime.now().year) {
          // if the year is equal to the current year

          if (chosenDay.month <= DateTime.now().month) {
            // if the month is equal or less than the current month in the current year

            if (chosenDay.month < DateTime.now().month) {
              // if the month is less than the current month in the current year
              saveTodayHabits();
            }

            if (chosenDay.month == DateTime.now().month) {
              // if the month is equal to the current month in the current year

              if (chosenDay.day < DateTime.now().day) {
                // if the day is equal or less than the current day in the current month in the current year
                saveTodayHabits();
              }
            }
          }
        }

        if (chosenDay.year < DateTime.now().year) {
          saveTodayHabits();
        }
      }
    }
  }

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    anyTime(context, chosenDay, boxIndex, isAdLoaded, interstitialAd),
    morning(context, chosenDay, boxIndex, isAdLoaded, interstitialAd),
    afternoon(context, chosenDay, boxIndex, isAdLoaded, interstitialAd),
    evening(context, chosenDay, boxIndex, isAdLoaded, interstitialAd),
  ]);
}
