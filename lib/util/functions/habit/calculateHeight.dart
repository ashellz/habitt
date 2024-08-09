import 'package:flutter/material.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/new_home_page.dart';

double calculateHabitsHeight(String? tagSelected, BuildContext context) {
  double deviceHeight = MediaQuery.of(context).size.height * 0.7;
  List<String> habitCategories = [
    "Morning",
    "Afternoon",
    "Evening",
    "Any time"
  ];

  List<String> emptyCategories = [
    "Morning",
    "Afternoon",
    "Evening",
    "Any time"
  ];

  if (tagSelected == 'All') {
    double height = 260;

    List<String> hasHabits = [];

    if (morningHasHabits) {
      hasHabits.add('Morning');
      emptyCategories.remove('Morning');
    }
    if (afternoonHasHabits) {
      hasHabits.add('Afternoon');
      emptyCategories.remove('Afternoon');
    }
    if (eveningHasHabits) {
      hasHabits.add('Evening');
      emptyCategories.remove('Evening');
    }
    if (anytimeHasHabits) {
      hasHabits.add('Any time');
      emptyCategories.remove('Any time');
    }

    for (int i = 0; i < hasHabits.length; i++) {
      height += 30;
    }

    for (int i = 0; i < habitBox.length; i++) {
      height += 65;
    }

    if (boolBox.get('displayEmptyCategories')!) {
      for (int i = 0; i < emptyCategories.length; i++) {
        height += 100;
      }
    }

    if (height < deviceHeight) {
      height = deviceHeight;
    }
    return height;
  } else if (!habitCategories.contains(tagSelected)) {
    double height = 100;

    for (int i = 0; i < habitBox.length; i++) {
      if (habitBox.getAt(i)?.tag == tagSelected) {
        height += 65;
      }
    }
    if (height < deviceHeight) {
      height = deviceHeight;
    }
    return height;
  } else {
    double height = 100;

    for (int i = 0; i < habitBox.length; i++) {
      if (habitBox.getAt(i)?.category == tagSelected) {
        height += 65;
      }
    }
    if (height < deviceHeight) {
      height = deviceHeight;
    }
    return height;
  }
}
