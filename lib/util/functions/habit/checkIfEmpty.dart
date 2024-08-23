import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:hive/hive.dart';

var habitListLenght = Hive.box<HabitData>('habits').length;

bool isEmpty(String category) {
  for (int i = 0; i < habitListLenght; i++) {
    if (habitBox.getAt(i)?.category == category) {
      return false;
    }
  }

  return true;
}

bool checkIfAllEmpty() {
  hasHabits();

  if (morningHasHabits == false &&
      afternoonHasHabits == false &&
      eveningHasHabits == false &&
      anytimeHasHabits == false) {
    return true;
  } else {
    return false;
  }
}
