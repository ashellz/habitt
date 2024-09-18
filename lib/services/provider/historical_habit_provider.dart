import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/data/historical_habit.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:vibration/vibration.dart';

class HistoricalHabitProvider extends ChangeNotifier {
  List get allHistoricalHabits => historicalBox.values.toList();

  List<HistoricalHabitData> historicalHabits_ = [];

  List get historicalHabits => historicalHabits_;

  HistoricalHabitData getHistoricalHabitAt(int index, DateTime today) {
    List<int> date = [today.year, today.month, today.day];

    for (int i = 0; i < historicalBox.length; i++) {
      List<int> habitDate = [
        historicalBox.getAt(i)!.date.year,
        historicalBox.getAt(i)!.date.month,
        historicalBox.getAt(i)!.date.day
      ];

      if (const ListEquality().equals(habitDate, date)) {
        return historicalBox.getAt(i)!.data[index];
      }
    }

    return historicalBox.getAt(0)!.data[index]; // default
  }

  void updateHistoricalHabits(DateTime date) {
    if (kDebugMode) {
      print("updating historical habits");
    }
    for (int i = 0; i < historicalBox.length; i++) {
      List intDate = [
        historicalBox.getAt(i)!.date.year,
        historicalBox.getAt(i)!.date.month,
        historicalBox.getAt(i)!.date.day
      ];
      if (const ListEquality()
          .equals(intDate, [date.year, date.month, date.day])) {
        historicalHabits_ = historicalBox.getAt(i)!.data;
      }
    }

    notifyListeners();
  }

  void applyCurentHabitData(List currentDate, int index,
      HistoricalHabitData habitData, DateTime time) {
    if (kDebugMode) {
      print("applying current habit data");
    }
    for (int i = 0; i < historicalBox.length; i++) {
      List<int> habitDate = [
        historicalBox.getAt(i)!.date.year,
        historicalBox.getAt(i)!.date.month,
        historicalBox.getAt(i)!.date.day
      ];
      if (const ListEquality().equals(currentDate, habitDate)) {
        List<HistoricalHabitData> currentHabitData =
            List.from(historicalBox.getAt(i)!.data);

        currentHabitData[index] = habitData;

        historicalBox.putAt(
            i,
            HistoricalHabit(
                date: historicalBox.getAt(i)!.date, data: currentHabitData));
        updateHistoricalHabits(time);
        break;
      }
    }
  }

  void skipHistoricalHabit(int index, habit, DateTime time) async {
    if (kDebugMode) {
      print("skipping historical habit");
    }
    List<int> chosenHabitDate = [time.year, time.month, time.day];

    var historicalList = historicalBox.values.toList();

    historicalList.sort((a, b) {
      DateTime dateA = a.date;
      DateTime dateB = b.date;
      return dateA
          .compareTo(dateB); // This will sort from oldest to most recent
    });

    for (int i = 0; i < historicalList.length; i++) {
      List habitDate = [
        historicalList[i].date.year,
        historicalList[i].date.month,
        historicalList[i].date.day
      ];

      if (const ListEquality().equals(habitDate, chosenHabitDate)) {
        if (i - 1 >= 0) {
          if (historicalList[i - 1].data[index].skipped) {
            Fluttertoast.showToast(
                msg: "You can't skip a habit two days in a row.");
            return;
          }
        }
        if (i + 1 < historicalList.length) {
          if (historicalList[i + 1].data[index].skipped) {
            Fluttertoast.showToast(
                msg: "You can't skip a habit two days in a row.");
            return;
          }
        }
      }
    }

    HistoricalHabitData habitData = HistoricalHabitData(
      name: habit.name,
      completed: !habit.completed,
      icon: habit.icon,
      category: habit.category,
      amount: habit.amount,
      amountCompleted: habit.completed ? habit.amount : 0,
      amountName: habit.amountName,
      duration: habit.duration,
      durationCompleted: habit.completed ? habit.duration : 0,
      skipped: !habit.skipped,
    );

    applyCurentHabitData(chosenHabitDate, index, habitData, time);

    calculateStreak();
    notifyListeners();
  }

  void completeHistoricalHabit(int index, habit, DateTime time) async {
    List<int> currentDate = [time.year, time.month, time.day];

    HistoricalHabitData habitData = HistoricalHabitData(
      name: habit.name,
      completed: !habit.completed,
      icon: habit.icon,
      category: habit.category,
      amount: habit.amount,
      amountCompleted: !habit.completed ? habit.amount : 0,
      amountName: habit.amountName,
      duration: habit.duration,
      durationCompleted: !habit.completed ? habit.duration : 0,
      skipped: false,
    );

    bool hapticFeedback = boolBox.get('hapticFeedback')!;
    /*if (allHabitsCompleted()) {
      playSound();
      if (hapticFeedback) {
        Vibration.vibrate(duration: 500);
      }
    } else*/
    if (!habit.completed) {
      if (hapticFeedback) {
        Vibration.vibrate(duration: 100);
      }
    }

    applyCurentHabitData(currentDate, index, habitData, time);

    calculateStreak();
    notifyListeners();
  }

  applyHistoricalAmountCompleted(
      habit, theAmountValue, DateTime time, int index) {
    List<int> currentDate = [time.year, time.month, time.day];

    HistoricalHabitData habitData = HistoricalHabitData(
        name: habit.name,
        completed: habit.completed,
        icon: habit.icon,
        category: habit.category,
        amount: habit.amount,
        amountCompleted: theAmountValue,
        amountName: habit.amountName,
        duration: habit.duration,
        durationCompleted: habit.durationCompleted,
        skipped: habit.skipped);

    applyCurentHabitData(currentDate, index, habitData, time);

    notifyListeners();
  }

  applyHistoricalDurationCompleted(habit, int theDurationValueHours,
      int theDurationValueMinutes, DateTime time, int index) {
    List<int> currentDate = [time.year, time.month, time.day];

    HistoricalHabitData habitData = HistoricalHabitData(
        name: habit.name,
        completed: habit.completed,
        icon: habit.icon,
        category: habit.category,
        amount: habit.amount,
        amountCompleted: habit.amountCompleted,
        amountName: habit.amountName,
        duration: habit.duration,
        durationCompleted: theDurationValueHours * 60 + theDurationValueMinutes,
        skipped: habit.skipped);

    applyCurentHabitData(currentDate, index, habitData, time);

    notifyListeners();
  }

  void calculateStreak() {
    var historicalList = historicalBox.values.toList();

    historicalList.sort((a, b) {
      DateTime dateA = a.date;
      DateTime dateB = b.date;
      return dateA
          .compareTo(dateB); // This will sort from oldest to most recent
    });

    for (int i = 0; i < habitBox.length; i++) {
      int longestStreak = 0;
      var habit = habitBox.getAt(i)!;

      bool completed = false;
      bool skipped = false;
      int streak = 0;

      for (int j = 0; j < historicalList.length - 1; j++) {
        if (historicalList[j].data.length <= i) {
          completed = false;
        } else {
          completed = historicalList[j].data[i].completed;
          skipped = historicalList[j].data[i].skipped;
        }

        if (streak > longestStreak) {
          longestStreak = streak;
        }

        if (completed) {
          if (!skipped) {
            streak++;
          }
        } else {
          streak = 0;
        }
      }

      habit.streak = streak;
      if (longestStreak > habit.longestStreak) {
        habit.longestStreak = longestStreak;
      }

      habit.save();
    }

    //ALL HABITS COMPLETED STREAK
    int allHabitsCompletedStreak = 0;

    for (int i = 0; i < historicalList.length - 1; i++) {
      int numberOfHabits = 0;
      int numberOfCompletedHabits = 0;
      bool isSkipped = false;
      // -1 is because the last one is the current day

      for (var habit in historicalList[i].data) {
        numberOfHabits++;
        if (habit.completed) {
          if (habit.skipped) {
            isSkipped = true;
          }
          numberOfCompletedHabits++;
        }
      }

      if (numberOfCompletedHabits == numberOfHabits) {
        if (!isSkipped) {
          allHabitsCompletedStreak++;
        }
      } else {
        allHabitsCompletedStreak = 0;
      }
    }

    streakBox.put('allHabitsCompletedStreak', allHabitsCompletedStreak);

    notifyListeners();
  }
}
