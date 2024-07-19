import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/edit_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/util/functions/habit/checkIfEmpty.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:hive/hive.dart';

var habitListLenght = Hive.box<HabitData>('habits').length;

late String editedFrom;
late String editedTo;

void editHabit(int index, context, editcontroller) {
  editedFrom = habitBox.getAt(index)!.category;
  editedTo = dropDownValue;
  editHeights();
  habitBox.putAt(
      index,
      HabitData(
        name: editcontroller.text,
        completed: false,
        icon: getIconString(updatedIcon.icon),
        category: dropDownValue,
        streak: habitBox.getAt(index)?.streak ?? 0,
        amount: habitGoalEdit == 1 ? amount : habitBox.getAt(index)!.amount,
        amountName: amountNameControllerEdit.text,
        amountCompleted: 0,
        duration: habitGoalEdit == 2
            ? duration
            : habitBox.getAt(index)?.duration ?? 0,
        durationCompleted: 0,
      ));

  checkIfEmpty(editedFrom);
  dropDownValue = 'Any time';
  editcontroller.text = "";
  updatedIcon = startIcon;
  Navigator.pop(context);
  hasHabits();
  openCategory("edited");
  // showPopup(context, "Habit edited!");
}

void editHeights() {
  if (editedFrom == "Morning") {
    morningHeight -= 82;
  } else if (editedFrom == "Afternoon") {
    afternoonHeight -= 82;
  } else if (editedFrom == "Evening") {
    eveningHeight -= 82;
  } else if (editedFrom == "Any time") {
    anyTimeHeight -= 82;
  }

  if (editedTo == "Morning") {
    morningHeight += 82;
    openCategory("no");
  } else if (editedTo == "Afternoon") {
    afternoonHeight += 82;
    openCategory("no");
  } else if (editedTo == "Evening") {
    eveningHeight += 82;
    openCategory("no");
  } else if (editedTo == "Any time") {
    anyTimeHeight += 82;
    openCategory("no");
  }
}

void openCategory(String key) {
  if (dropDownValue == "Morning") {
    if (morningHasHabits == false) {
      morningHasHabits = true;
    }
    if (morningVisible == false) {
      morningVisible = true;
      for (int i = 0; i < habitListLenght; i++) {
        if (habitBox.getAt(i)?.category == 'Morning') {
          morningHeight += 82;
        }
      }
    } else if (key == "created") {
      morningHeight += 82;
    }
  } else if (dropDownValue == "Afternoon") {
    if (afternoonHasHabits == false) {
      afternoonHasHabits = true;
    }
    if (afternoonVisible == false) {
      afternoonVisible = true;
      for (int i = 0; i < habitListLenght; i++) {
        if (habitBox.getAt(i)?.category == 'Afternoon') {
          afternoonHeight += 82;
        }
      }
    } else if (key == "created") {
      afternoonHeight += 82;
    }
  } else if (dropDownValue == "Evening") {
    if (eveningHasHabits == false) {
      eveningHasHabits = true;
    }
    if (eveningVisible == false) {
      eveningVisible = true;
      for (int i = 0; i < habitListLenght; i++) {
        if (habitBox.getAt(i)?.category == 'Evening') {
          eveningHeight += 82;
        }
      }
    } else if (key == "created") {
      eveningHeight += 82;
    }
  } else if (dropDownValue == "Any time") {
    if (anytimeHasHabits == false) {
      anytimeHasHabits = true;
    }
    if (anyTimeVisible == false) {
      anyTimeVisible = true;
      for (int i = 0; i < habitListLenght; i++) {
        if (habitBox.getAt(i)?.category == 'Any time') {
          anyTimeHeight += 82;
        }
      }
    } else if (key == "created") {
      anyTimeHeight += 82;
    }
  }
}
