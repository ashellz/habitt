import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/home/home_page.dart';
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
