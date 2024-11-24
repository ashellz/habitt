import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';

String translateCategory(String category, BuildContext context) {
  switch (category) {
    case "All":
      return AppLocale.all.getString(context);
    case "Any time":
      return AppLocale.anyTime.getString(context);
    case "Morning":
      return AppLocale.morning.getString(context);
    case "Afternoon":
      return AppLocale.afternoon.getString(context);
    case "Evening":
      return AppLocale.evening.getString(context);
    default:
      return category;
  }
}

String translateTag(String tag, BuildContext context) {
  switch (tag) {
    case "No tag":
      return AppLocale.noTag.getString(context);
    case "Healthy Lifestyle":
      return AppLocale.healthyLifestyle.getString(context);
    case "Better Sleep":
      return AppLocale.betterSleep.getString(context);
    case "Morning Routine":
      return AppLocale.morningRoutine.getString(context);
    case "Workout":
      return AppLocale.workout.getString(context);
    default:
      return tag;
  }
}

String translateBoth(String text, BuildContext context) {
  switch (text) {
    case "All":
      return AppLocale.all.getString(context);
    case "Any time":
      return AppLocale.anyTime.getString(context);
    case "Morning":
      return AppLocale.morning.getString(context);
    case "Afternoon":
      return AppLocale.afternoon.getString(context);
    case "Evening":
      return AppLocale.evening.getString(context);
    case "Healthy Lifestyle":
      return AppLocale.healthyLifestyle.getString(context);
    case "Better Sleep":
      return AppLocale.betterSleep.getString(context);
    case "Morning Routine":
      return AppLocale.morningRoutine.getString(context);
    case "Workout":
      return AppLocale.workout.getString(context);
    default:
      return text;
  }
}
