import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/home/home_page.dart';

class DataProvider extends ChangeNotifier {
  String allHabitsTagSelected = "Categories";
  List<String> categoriesList = [];
  List<String> tagsList =
      []; // This list is going to be empty except when initialized in onboarding page
  bool accountDeletionPending = boolBox.get("accountDeletionPending")!;

  List<String> greetingTexts = [];
  String greetingText = "";

  List<HabitData> tasksList = [];
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

  void setAllHabitsTagSelected(String value) {
    allHabitsTagSelected = value;
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

  void updateHabits() {
    habitsList = habitBox.values.toList();
    tasksList = habitsList.where((habit) => habit.task).toList();
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
