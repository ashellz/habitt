import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

void saveHabitsForToday(BuildContext context) async {
  DateTime today = DateTime.now();
  List<HistoricalHabitData> habitsForToday = [];
  List<int> todayDate = [today.year, today.month, today.day];
  List<HabitData> habitsList =
      Provider.of<DataProvider>(context, listen: false).habitsList;

  // Loop through all habits in your habitBox
  for (var habit in habitsList) {
    // Create HistoricalHabitData for each habit
    HistoricalHabitData historicalHabit = HistoricalHabitData(
      name: habit.name,
      completed: habit.completed,
      icon: habit.icon,
      category: habit.category,
      amount: habit.amount,
      amountCompleted: habit.amountCompleted,
      amountName: habit.amountName,
      duration: habit.duration,
      durationCompleted: habit.durationCompleted,
      skipped: habit.skipped,
      id: habit.id,
      task: habit.task,
      type: habit.type,
      weekValue: habit.weekValue,
      monthValue: habit.monthValue,
      customValue: habit.customValue,
      selectedDaysAWeek: habit.selectedDaysAWeek,
      selectedDaysAMonth: habit.selectedDaysAMonth,
    );

    // Add the habit data to the list for today
    habitsForToday.add(historicalHabit);
  }

  bool todayExists = false;

  for (var key in historicalBox.keys) {
    final historicalItem = historicalBox.get(key);
    if (historicalItem != null) {
      List<int> date = [
        historicalItem.date.year,
        historicalItem.date.month,
        historicalItem.date.day
      ];

      if (const ListEquality().equals(date, todayDate)) {
        todayExists = true;

        historicalItem.data.clear();
        historicalItem.data.addAll(habitsForToday);
        await historicalBox.put(key, historicalItem);
        break;
      }
    }
  }

  if (!todayExists) {
    await historicalBox.add(HistoricalHabit(date: today, data: habitsForToday));

    var historicalList = historicalBox.keys.map((key) {
      final value = historicalBox.get(key);
      return {'key': key, 'value': value};
    }).toList();

    historicalList.sort((a, b) {
      DateTime dateA = a['value']!.date;
      DateTime dateB = b['value']!.date;
      return dateB.compareTo(dateA); // Today is 0
    });

    if (historicalList.length > 1) {
      final secondMostRecent = historicalList[1]['value'];
      final secondKey = historicalList[1]['key'];

      if (secondMostRecent != null) {
        secondMostRecent.data.removeWhere((habit) {
          if (habit.type == "Weekly" && habit.selectedDaysAWeek.isNotEmpty) {
            int weekDay = today.weekday;
            int timesCompletedThisWeek = 0;
            int weekValue = habit.weekValue;

            for (var todayHabit in habitBox.values) {
              if (todayHabit.id == habit.id) {
                timesCompletedThisWeek = todayHabit.timesCompletedThisWeek;
              }
            }

            return (weekDay - 1) + weekValue <= (7 + timesCompletedThisWeek);
          }
          return false;
        });

        // Save updated data back to the box
        await historicalBox.put(secondKey, secondMostRecent);

        secondMostRecent.data.removeWhere((habit) {
          if (habit.type == "Monthly" && habit.selectedDaysAMonth.isNotEmpty) {
            int day = today.day;
            int timesCompletedThisMonth = 0;
            int monthValue = habit.monthValue;

            int getDaysInMonth(int year, int month) {
              if (month == DateTime.february) {
                final bool isLeapYear =
                    (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
                return isLeapYear ? 29 : 28;
              }
              const List<int> daysInMonth = <int>[
                31,
                -1,
                31,
                30,
                31,
                30,
                31,
                31,
                30,
                31,
                30,
                31
              ];
              return daysInMonth[month - 1];
            }

            for (var todayHabit in habitBox.values) {
              if (todayHabit.id == habit.id) {
                timesCompletedThisMonth = todayHabit.timesCompletedThisMonth;
              }
            }

            return (day - 1) + monthValue <=
                (getDaysInMonth(today.year, today.month) +
                    timesCompletedThisMonth);
          }
          return false;
        });

        // Save updated data back to the box
        await historicalBox.put(secondKey, secondMostRecent);
      }
    }
  }
}
