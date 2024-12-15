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
  for (int i = 0; i < historicalBox.length; i++) {
    List<int> date = [
      historicalBox.getAt(i)!.date.year,
      historicalBox.getAt(i)!.date.month,
      historicalBox.getAt(i)!.date.day
    ];

    if (const ListEquality().equals(date, todayDate)) {
      todayExists = true;
      historicalBox.getAt(i)!.data.clear();
      historicalBox.getAt(i)!.data.addAll(habitsForToday);
      await historicalBox.getAt(i)!.save();
      break;
    }
  }

  if (!todayExists) {
    await historicalBox.add(HistoricalHabit(date: today, data: habitsForToday));
  }
}
