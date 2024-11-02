import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';

class DataProvider extends ChangeNotifier {
  List<String> tagsList =
      []; // This list is going to be empty except when initialized in onboarding page

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

  void addToTagsList(String tag) {
    tagsList.add(tag);
    notifyListeners();
  }
}
