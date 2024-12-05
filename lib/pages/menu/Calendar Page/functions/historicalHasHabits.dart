import 'package:flutter/material.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:provider/provider.dart';

bool historicalHasHabits(category, BuildContext context) {
  int habitListLength =
      context.watch<HistoricalHabitProvider>().historicalHabits.length;
  List<HistoricalHabitData> habitsOnDate =
      context.watch<HistoricalHabitProvider>().historicalHabits;

  for (int i = 0; i < habitListLength; i++) {
    if (habitsOnDate[i].category == category && !habitsOnDate[i].task) {
      return true;
    }
  }
  return false;
}
