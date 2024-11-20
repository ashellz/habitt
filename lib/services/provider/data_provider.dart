import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/home/home_page.dart';

class DataProvider extends ChangeNotifier {
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
  int customValueSelected = 0;

  List<bool> selectedDaysAWeek = List.generate(7, (index) => false);

  List<bool> selectedDaysAMonth = List.generate(31, (index) => false);

  bool showMoreOptionsWeekly = false;
  bool showMoreOptionsMonthly = false;

  // complete habit dialog

  int theAmountValue = 0;
  int theDurationValueHours = 0;
  int theDurationValueMinutes = 0;

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
    selectedDaysAWeek = List.generate(7, (index) => false);
    notifyListeners();
  }

  void unselectAllDaysAMonth() {
    selectedDaysAMonth = List.generate(31, (index) => false);
    notifyListeners();
  }

  void selectDaysAWeek(List<bool> days) {
    selectedDaysAWeek = days;
    notifyListeners();
  }

  void selectDaysAMonth(List<bool> days) {
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

  void updateHabitType(String value) {
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
      AppLocale.noTag.getString(context),
      AppLocale.healthyLifestyle.getString(context),
      AppLocale.betterSleep.getString(context),
      AppLocale.morningRoutine.getString(context),
      AppLocale.workout.getString(context),
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
