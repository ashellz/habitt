import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/checkForNotifications.dart';
import 'package:habitt/util/functions/getSortedHistoricalList.dart';
import 'package:habitt/util/functions/habit/getCustomAppearance.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:provider/provider.dart';

class DataProvider extends ChangeNotifier {
  bool morningHasHabits = false;
  bool afternoonHasHabits = false;
  bool eveningHasHabits = false;
  bool anytimeHasHabits = false;

  List<HistoricalHabitData> addHabitsList = [];

  bool isNotificationVisible = false;

  List<String> categoriesList = [];
  List<String> tagsList =
      []; // This list is going to be empty except when initialized in onboarding page
  bool accountDeletionPending = boolBox.get("accountDeletionPending")!;

  List<String> greetingTexts = [];
  String greetingText = "";

  List<HabitData> tasksList = [];
  List<HabitData> allHabitsList = [];
  List<HabitData> habitsList = [];
  TextEditingController habitTypeController = TextEditingController();

  int weekValueSelected = 0;
  int monthValueSelected = 0;
  int customValueSelected = 2;

  List selectedDaysAWeek = [];

  List selectedDaysAMonth = [];

  bool showMoreOptionsWeekly = false;
  bool showMoreOptionsMonthly = false;

  // complete habit dialog

  int theAmountValue = 0;
  int theDurationValueHours = 0;
  int theDurationValueMinutes = 0;

  void selectHabit(HistoricalHabitData habit, bool? value) {
    if (value ?? false) {
      addHabitsList.add(habit);
    } else {
      addHabitsList.remove(habit);
    }

    notifyListeners();
  }

  void setAmountValue(int value) {
    theAmountValue = value;
    notifyListeners();
  }

  void setDurationValueHours(int value) {
    theDurationValueHours = value;
    notifyListeners();
  }

  void setDurationValueMinutes(int value) {
    theDurationValueMinutes = value;
    notifyListeners();
  }

  void setShowMoreOptionsWeekly(bool value) {
    showMoreOptionsWeekly = value;
    notifyListeners();
  }

  void setShowMoreOptionsMonthly(bool value) {
    showMoreOptionsMonthly = value;
    notifyListeners();
  }

  void unselectAllDaysAWeek() {
    selectedDaysAWeek = [];
    notifyListeners();
  }

  void unselectAllDaysAMonth() {
    selectedDaysAMonth = [];
    notifyListeners();
  }

  void selectDaysAWeek(List days) {
    selectedDaysAWeek = days;
    notifyListeners();
  }

  void selectDaysAMonth(List days) {
    selectedDaysAMonth = days;
    notifyListeners();
  }

  void setCustomValueSelected(int value) {
    customValueSelected = value;
    notifyListeners();
  }

  void increaseCustomValueSelected() {
    customValueSelected++;
    notifyListeners();
  }

  void setMonthValueSelected(int value) {
    monthValueSelected = value;
    notifyListeners();
  }

  void increaseMonthValueSelected() {
    monthValueSelected++;
    notifyListeners();
  }

  void setWeekValueSelected(int value) {
    weekValueSelected = value;
    notifyListeners();
  }

  void increaseWeekValueSelected() {
    weekValueSelected++;
    notifyListeners();
  }

  void updateHabitType(String value, BuildContext context) {
    if (value == "Daily") {
      value = AppLocale.daily.getString(context);
    } else if (value == "Weekly") {
      value = AppLocale.weekly.getString(context);
    } else if (value == "Monthly") {
      value = AppLocale.monthly.getString(context);
    } else if (value == "Custom") {
      value = AppLocale.custom.getString(context);
    }

    habitTypeController.text = value;
    notifyListeners();
  }

  void updateAllHabits() {
    allHabitsList = habitBox.values.toList();
    notifyListeners();
  }

  Future<void> updateHabits(BuildContext context) async {
    DateTime today = DateTime.now();
    habitsList = [];

    anytimeHasHabits = false;
    morningHasHabits = false;
    afternoonHasHabits = false;
    eveningHasHabits = false;

    void showCategory(String category) {
      if (category == "Any time") {
        anytimeHasHabits = true;
      } else if (category == "Morning") {
        morningHasHabits = true;
      } else if (category == "Afternoon") {
        afternoonHasHabits = true;
      } else if (category == "Evening") {
        eveningHasHabits = true;
      }
    }

    for (var habit in habitBox.values) {
      if (!habit.paused) {
        if (habit.type == "Daily") {
          showCategory(habit.category);
          habitsList.add(habit);
        } else if (habit.type == "Weekly") {
          if (habit.selectedDaysAWeek.isEmpty) {
            if (habit.timesCompletedThisWeek < habit.weekValue) {
              showCategory(habit.category);
              habitsList.add(habit);
            }
          } else {
            if (habit.selectedDaysAWeek.contains(today.weekday)) {
              showCategory(habit.category);
              habitsList.add(habit);
            }
          }
        } else if (habit.type == "Monthly") {
          if (habit.selectedDaysAMonth.isEmpty) {
            if (habit.timesCompletedThisMonth < habit.monthValue) {
              showCategory(habit.category);
              habitsList.add(habit);
            }
          } else {
            if (habit.selectedDaysAMonth.contains(today.day)) {
              showCategory(habit.category);
              habitsList.add(habit);
            }
          }
        } else if (habit.type == "Custom") {
          if (DateTime.now().difference(habit.lastCustomUpdate).inDays >= 29) {
            List<DateTime> customAppearance = getCustomAppearance(habit.id);
            habit.customAppearance = customAppearance;
            habit.lastCustomUpdate = DateTime.now();
            habit.save();
          }

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
            if (day[0] == today.year &&
                day[1] == today.month &&
                day[2] == today.day) {
              showCategory(habit.category);
              habitsList.add(habit);
              break;
            }
          }
        }
      } else if (habit.type == "Custom") {
        if (habit.lastCustomUpdate.difference(today).inDays < 30) {
          List historicalList = getSortedHistoricalList();

          for (int i = 0; i < historicalList.length; i++) {
            var otherHabit =
                historicalList[i].where((element) => element.id == habit.id);

            if (otherHabit.isNotEmpty) {
              DateTime day = historicalList[i].date;
              DateTime daySimplified = DateTime(
                day.year,
                day.month,
                day.day,
              );

              if (daySimplified
                      .difference(DateTime(today.year, today.month, today.day))
                      .inDays >=
                  otherHabit.first.customValue) {
                habit.lastCustomUpdate =
                    today.subtract(const Duration(days: 30));
              }
              break;
            }
          }
        }
      }
    }

    // potential optional feature
    // habitsList.sort((a, b) {
    // return a.completed ? 1 : -1; // Completed items go to the bottom.
    // });

    tasksList = habitsList.where((habit) => habit.task).toList();

    context.read<HabitProvider>().chooseMainCategory(context);
    context.read<HabitProvider>().updateMainCategoryHeight(context);
    saveHabitsForToday(context);
    checkForNotifications(context);

    notifyListeners();
  }

  void updateAccountDeletionPending(bool value) {
    accountDeletionPending = value;
    boolBox.put("accountDeletionPending", value);
    notifyListeners();
  }

  // Initialize tagsList with context to access localization
  void initializeTagsList(BuildContext context) {
    tagsList = [
      "No tag",
      "Healthy Lifestyle",
      "Better Sleep",
      "Morning Routine",
      "Workout"
    ];

    notifyListeners();
  }

  void initializeLists(context) {
    greetingTexts = [
      AppLocale.hiThere.getString(context),
      AppLocale.heyThere.getString(context),
      AppLocale.helloThere.getString(context),
      AppLocale.hello.getString(context),
      AppLocale.hi.getString(context),
      AppLocale.hey.getString(context),
      AppLocale.whatsUp.getString(context)
    ];

    categoriesList = [
      AppLocale.all.getString(context),
    ];

    String timeBasedText = "";
    int hour = DateTime.now().hour;

    if (hour >= 4 && hour < 12) {
      timeBasedText = AppLocale.goodMorning.getString(context);
    } else if (hour >= 12 && hour < 19) {
      timeBasedText = AppLocale.goodAfternoon.getString(context);
    } else {
      timeBasedText = AppLocale.goodEvening.getString(context);
    }

    if (!greetingTexts.contains(timeBasedText)) {
      greetingTexts.add(timeBasedText);
    }

    greetingText = greetingTexts[Random().nextInt(greetingTexts.length)];

    notifyListeners();
  }

  void addToTagsList(String tag) {
    tagsList.add(tag);
    notifyListeners();
  }
}
