import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/old/home_page.dart';
import 'package:hive/hive.dart';

var habitListLenght = Hive.box<HabitData>('habits').length;

void checkIfEmpty(String category) {
  bool hasHabits = false;
  for (int i = 0; i < habitListLenght; i++) {
    if (habitBox.getAt(i)?.category == category) {
      hasHabits = true;
      break;
    }
  }

  if (hasHabits == false) {
    if (category == "Morning") {
      morningHasHabits = false;
      morningVisible = false;
    } else if (category == "Afternoon") {
      afternoonHasHabits = false;
      afternoonVisible = false;
    } else if (category == "Evening") {
      eveningHasHabits = false;
      eveningVisible = false;
    } else if (category == "Any time") {
      anytimeHasHabits = false;
      anyTimeVisible = false;
    }
  }
}
