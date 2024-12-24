import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/home/home_page.dart';

HabitData getHabitFromId(int id) {
  for (var habit in habitBox.values) {
    if (habit.id == id) {
      return habit;
    }
  }

  return habitBox.getAt(0)!;
}
