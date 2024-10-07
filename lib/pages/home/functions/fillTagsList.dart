import 'package:flutter/material.dart';
import 'package:habitt/main.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:provider/provider.dart';

void fillTagsList(BuildContext context) {
  categoriesList = ["All"];

  void addAnytime() {
    if (!categoriesList.contains("Any time")) {
      categoriesList.add("Any time");
    }
  }

  void addMorning() {
    if (!categoriesList.contains("Morning")) {
      categoriesList.add("Morning");
    }
  }

  void addAfternoon() {
    if (!categoriesList.contains("Afternoon")) {
      categoriesList.add("Afternoon");
    }
  }

  void addEvening() {
    if (!categoriesList.contains("Evening")) {
      categoriesList.add("Evening");
    }
  }

  if (context.watch<HabitProvider>().displayEmptyCategories) {
    addAnytime();
    addMorning();
    addAfternoon();
    addEvening();
  } else {
    if (anytimeHasHabits) {
      addAnytime();
    } else {
      categoriesList.remove("Any time");
    }
    if (morningHasHabits) {
      addMorning();
    } else {
      categoriesList.remove("Morning");
    }
    if (afternoonHasHabits) {
      addAfternoon();
    } else {
      categoriesList.remove("Afternoon");
    }
    if (eveningHasHabits) {
      addEvening();
    } else {
      categoriesList.remove("Evening");
    }
  }

  categoriesList.sort((a, b) {
    const order = ["All", "Any time", "Morning", "Afternoon", "Evening"];
    return order.indexOf(a).compareTo(order.indexOf(b));
  });

  for (int i = 0; i < tagBox.length; i++) {
    String tag = tagBox.getAt(i)!.tag;
    if (!tagsList.contains(tag)) {
      tagsList.add(tag);
    }
  }

  for (int i = 0; i < tagsList.length; i++) {
    if (tagsList[i] != 'No tag' && !categoriesList.contains(tagsList[i])) {
      categoriesList.add(tagsList[i]);
    }
  }
}
