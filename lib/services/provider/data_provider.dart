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
