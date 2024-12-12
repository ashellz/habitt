import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:provider/provider.dart';

class HistoricalHabitProvider extends ChangeNotifier {
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

  int boxIndex = 0;

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
        boxIndex = i;
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
      return dateB.compareTo(dateA);
    }); // today is 0

    for (int i = 0; i < historicalList.length; i++) {
      List<int> habitDate = [
        historicalList[i].date.year,
        historicalList[i].date.month,
        historicalList[i].date.day
      ];

      // loop until day is found, get day index, start loop from index to today, and another from index to the past
      // stop the second loop when day with the same habit is found, check if its skipped

      if (const ListEquality().equals(habitDate, chosenHabitDate)) {
        for (int j = 0; j < historicalList[i].data.length; j++) {
          if (historicalList[i].data[j].skipped) {
            habitsSkipped += 1;
          }
        }

        if (habitsSkipped >= 3) {
          Fluttertoast.showToast(
              msg: AppLocale.cantSkipHabit3.getString(context));
          return;
        }

        for (int j = i - 1; j >= 0; j--) {
          // goes from chosen day to today

          for (int k = 0; k < historicalList[j].data.length; k++) {
            if (historicalList[j].data[k].id == habit.id) {
              if (historicalList[j].data[k].skipped) {
                Fluttertoast.showToast(
                    msg: AppLocale.cantSkipHabitRow.getString(context));
                return;
              }
              break;
            }
          }
        }

        for (int j = i + 1; j < historicalList.length; j++) {
          // goes from chosen to past

          for (int k = 0; k < historicalList[j].data.length; k++) {
            if (historicalList[j].data[k].id == habit.id) {
              if (historicalList[j].data[k].skipped) {
                Fluttertoast.showToast(
                    msg: AppLocale.cantSkipHabitRow.getString(context));
                return;
              }
              break;
            }
          }
        }

        break;
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

    HabitData? todayHabit;
    bool isThisWeek = false;
    bool isThisMonth = false;

    for (int i = 0; i < habitBox.length; i++) {
      if (habitBox.getAt(i)!.id == habit.id) {
        todayHabit = habitBox.getAt(i)!;
        break;
      }
    }

    if (todayHabit != null) {
      if (time.year == DateTime.now().year) {
        if (time.month == DateTime.now().month) {
          if (time.day != DateTime.now().day) {
            isThisMonth = true;
          }
          if (time.weekday < DateTime.now().weekday) {
            isThisWeek = true;
          }
        }
      }
    }

    if (!habit.completed) {
      if (todayHabit != null) {
        if (isThisWeek) {
          todayHabit.timesCompletedThisWeek++;
          context.read<DataProvider>().updateHabits(context);
        }
        if (isThisMonth) {
          todayHabit.timesCompletedThisMonth++;
          context.read<DataProvider>().updateHabits(context);
        }
        todayHabit.save();
      }

      if (hapticFeedback) {
        HapticFeedback.mediumImpact();
      }
    } else {
      if (todayHabit != null) {
        if (isThisWeek) {
          todayHabit.timesCompletedThisWeek--;
          context.read<DataProvider>().updateHabits(context);
        }
        if (isThisMonth) {
          todayHabit.timesCompletedThisMonth--;
          context.read<DataProvider>().updateHabits(context);
        }
        todayHabit.save();
      }
    }

    applyCurentHabitData(currentDate, index, habitData, time);

    calculateStreak(context);
    notifyListeners();
  }

  applyHistoricalAmountCompleted(
      habit, BuildContext context, DateTime time, int index) {
    List<int> currentDate = [time.year, time.month, time.day];

    int theAmountValue =
        Provider.of<DataProvider>(context, listen: false).theAmountValue;

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

  applyHistoricalDurationCompleted(
      habit, BuildContext context, DateTime time, int index) {
    List<int> currentDate = [time.year, time.month, time.day];

    int theDurationValueHours =
        Provider.of<DataProvider>(context, listen: false).theDurationValueHours;
    int theDurationValueMinutes =
        Provider.of<DataProvider>(context, listen: false)
            .theDurationValueMinutes;

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
      return dateB.compareTo(dateA); // today is 0
    });

    for (int i = 0; i < habitBox.length; i++) {
      int longestStreak = 0;
      var habit = habitBox.getAt(i)!;

      bool shouldBreak = false;
      bool completed = false;
      bool skipped = false;
      int streak = 0;
      DateTime? firstHabitDate;
      int completedHabits = 0;

      for (int j = 1; j < historicalList.length; j++) {
        for (var historicalHabit in historicalList[j].data) {
          if (historicalHabit.id == habit.id) {
            firstHabitDate ??= historicalList[j].date;
            completed = historicalHabit.completed;
            skipped = historicalHabit.skipped;

            if (habit.type == 'Daily') {
              if (completed) {
                if (!skipped) {
                  streak++;
                }
              } else {
                shouldBreak = true;
                break;
              }
            }

            if (habit.type == 'Weekly') {
              if (habit.selectedDaysAWeek.isNotEmpty) {
                if (completed) {
                  if (!skipped) {
                    streak++;
                  }
                } else {
                  shouldBreak = true;
                  break;
                }
              } else {
                int weekDay = historicalList[j].date.weekday;
                Duration differnce =
                    historicalList[j].date.difference(firstHabitDate);

                if (weekDay == 7) {
                  if (firstHabitDate.weekday != 7 || differnce.inDays >= 7) {
                    if (completedHabits < habit.weekValue) {
                      shouldBreak = true;
                      break;
                    }
                  }
                  completedHabits = 0;
                }

                if (completed) {
                  completedHabits++;
                  if (!skipped) {
                    streak++;
                  }
                }
              }
            }

            if (habit.type == 'Monthly') {
              if (habit.selectedDaysAMonth.isNotEmpty) {
                if (completed) {
                  if (!skipped) {
                    streak++;
                  }
                } else {
                  shouldBreak = true;
                  break;
                }
              } else {
                if (historicalList[j].date.month != DateTime.now().month &&
                    historicalList[j].date.day == 1) {
                  if (completedHabits < habit.monthValue) {
                    shouldBreak = true;
                    break;
                  }
                  completedHabits = 0;
                }

                if (completed) {
                  completedHabits++;
                  if (!skipped) {
                    streak++;
                  }
                }
              }
            }

            if (streak > longestStreak) {
              longestStreak = streak;
            }
          }
        }

        if (shouldBreak) {
          break;
        }
      }

      habit.streak = streak;
      habit.longestStreak = longestStreak;

      habit.save();
    }

    //ALL HABITS COMPLETED STREAK
    int allHabitsCompletedStreak = 0;

    for (int i = 1; i < historicalList.length; i++) {
      int numberOfHabits = 0;
      int numberOfCompletedHabits = 0;
      bool isSkipped = false;

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
          break;
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

  void importCurrentHabits(DateTime today, BuildContext context) {
    print("importing current habits");
    List<int> date = [today.year, today.month, today.day];

    List habitsList =
        Provider.of<DataProvider>(context, listen: false).habitsList;

    for (int i = 0; i < historicalBox.length; i++) {
      List<int> habitDate = [
        historicalBox.getAt(i)!.date.year,
        historicalBox.getAt(i)!.date.month,
        historicalBox.getAt(i)!.date.day
      ];

      if (const ListEquality().equals(habitDate, date)) {
        historicalBox.getAt(i)!.data.clear();
        for (var currentHabit in habitsList) {
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
