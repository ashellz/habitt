import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:provider/provider.dart';

class HistoricalHabitProvider extends ChangeNotifier {
  List get allHistoricalHabits => historicalBox.values.toList();

  DateTime calendarDay = DateTime.now();

  List<HistoricalHabitData> historicalHabits = [];

  changeCalendarDay(DateTime day) {
    calendarDay = day;
  }

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
        historicalHabits = historicalBox.getAt(i)!.data;
        notifyListeners();
        break;
      } else {
        historicalHabits = [];
        notifyListeners();
      }
    }
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

  void skipHistoricalHabit(
      int index, habit, DateTime time, BuildContext context) async {
    int habitsSkipped = 0;

    // Check if the user skipped a habit two days in a row or skipped 3 habits a day already
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
        for (int j = 0; j < historicalList[i].data.length; j++) {
          if (historicalList[i].data[j].skipped) {
            habitsSkipped += 1;
          }
        }

        if (habitsSkipped >= 3) {
          Fluttertoast.showToast(
              msg: "You can't skip more than 3 habits a day.");
          return;
        }

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
      amountName: habit.amountName,
      amountCompleted: habit.amountCompleted,
      duration: habit.duration,
      durationCompleted: habit.durationCompleted,
      skipped: !habit.skipped,
      id: habit.id,
      task: habit.task,
    );

    applyCurentHabitData(chosenHabitDate, index, habitData, time);

    calculateStreak(context);
    notifyListeners();
  }

  void completeHistoricalHabit(
      int index, habit, DateTime time, BuildContext context) async {
    List<int> currentDate = [time.year, time.month, time.day];

    HistoricalHabitData habitData = HistoricalHabitData(
      name: habit.name,
      completed: !habit.completed,
      icon: habit.icon,
      category: habit.category,
      amount: habit.amount,
      amountName: habit.amountName,
      amountCompleted: !habit.completed
          ? habit.amount
          : !habit.skipped
              ? 0
              : habit.amountCompleted,
      duration: habit.duration,
      durationCompleted: !habit.completed
          ? habit.duration
          : !habit.skipped
              ? 0
              : habit.durationCompleted,
      skipped: false,
      id: habit.id,
      task: habit.task,
    );

    bool hapticFeedback = boolBox.get('hapticFeedback')!;
    /*if (allHabitsCompleted()) {
      playSound();
      if (hapticFeedback) {
        HapticFeedback.heavyImpact();
      }
    } else*/
    if (!habit.completed) {
      if (hapticFeedback) {
        HapticFeedback.mediumImpact();
      }
    }

    applyCurentHabitData(currentDate, index, habitData, time);

    calculateStreak(context);
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
        skipped: habit.skipped,
        id: habit.id,
        task: habit.task);

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
        skipped: habit.skipped,
        id: habit.id,
        task: habit.task);

    applyCurentHabitData(currentDate, index, habitData, time);

    notifyListeners();
  }

  void calculateStreak(BuildContext context) {
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

        if (completed) {
          if (!skipped) {
            streak++;
          }
        } else {
          streak = 0;
        }

        if (streak > longestStreak) {
          longestStreak = streak;
        }
      }

      habit.streak = streak;
      habit.longestStreak = longestStreak;

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
        if (!habit.task) {
          numberOfHabits++;
          if (habit.completed) {
            if (habit.skipped) {
              isSkipped = true;
            }
            numberOfCompletedHabits++;
          }
        }
      }

      if (numberOfHabits != 0) {
        if (numberOfCompletedHabits == numberOfHabits) {
          if (!isSkipped) {
            allHabitsCompletedStreak++;
          }
        } else {
          allHabitsCompletedStreak = 0;
        }
      }
    }

    Provider.of<HabitProvider>(context, listen: false)
        .updateAllHabitsCompletedStreak(allHabitsCompletedStreak);

    notifyListeners();
  }

  editHistoricalHabit(index) {
    int id = habitBox.getAt(index)!.id;

    for (int i = 0; i < historicalBox.length; i++) {
      for (int j = 0; j < historicalBox.getAt(i)!.data.length; j++) {
        if (historicalBox.getAt(i)!.data[j].id == id) {
          historicalBox.getAt(i)!.data[j].name = habitBox.getAt(index)!.name;
          historicalBox.getAt(i)!.data[j].icon = habitBox.getAt(index)!.icon;
          historicalBox.getAt(i)!.data[j].category =
              habitBox.getAt(index)!.category;
        }
      }
    }

    notifyListeners();
  }

  void importCurrentHabits(DateTime today) {
    print("importing current habits");
    List<int> date = [today.year, today.month, today.day];

    for (int i = 0; i < historicalBox.length; i++) {
      List<int> habitDate = [
        historicalBox.getAt(i)!.date.year,
        historicalBox.getAt(i)!.date.month,
        historicalBox.getAt(i)!.date.day
      ];

      if (const ListEquality().equals(habitDate, date)) {
        historicalBox.getAt(i)!.data.clear();
        for (int j = 0; j < habitBox.length; j++) {
          var currentHabit = habitBox.getAt(j)!;
          historicalBox.getAt(i)!.data.add(HistoricalHabitData(
                name: currentHabit.name,
                completed: false,
                icon: currentHabit.icon,
                category: currentHabit.category,
                amount: currentHabit.amount,
                amountCompleted: 0,
                amountName: currentHabit.amountName,
                duration: currentHabit.duration,
                durationCompleted: 0,
                skipped: false,
                id: currentHabit.id,
                task: currentHabit.task,
              ));
        }

        updateHistoricalHabits(today);
        notifyListeners();
        break;
      }
    }
  }
}
