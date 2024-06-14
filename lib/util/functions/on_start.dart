import 'package:habit_tracker/data/habit_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

final streakBox = Hive.box<int>('streak');
final habitBox = Hive.box<HabitData>('habits');

void updateLastOpenedDate() async {
  DateTime now = DateTime.now();
  int day = now.day;
  int lastOpenedDate = streakBox.get('lastOpenedDate') ?? 0;
  int daysDifference = day - lastOpenedDate;
  if (daysDifference > 0) {
    resetOrUpdateStreaks(daysDifference);
  }
  streakBox.put('lastOpenedDate', day);
}

void resetOrUpdateStreaks(int daysDifference) {
  bool allHabitsCompleted = true;
  for (int i = 0; i < habitBox.length; i++) {
    var habit = habitBox.getAt(i)!;
    if (daysDifference == 1) {
      if (habit.completed) {
        habit.streak += 1;
      } else {
        allHabitsCompleted = false;
        habit.streak = 0;
      }
    } else {
      allHabitsCompleted = false;
      habit.streak = 0;
    }
    habit.completed = false;
    habit.save();
  }

  int allHabitsCompletedStreak = streakBox.get('allHabitsCompletedStreak') ?? 0;

  if (allHabitsCompleted) {
    allHabitsCompletedStreak += 1;
    streakBox.put('allHabitsCompletedStreak', allHabitsCompletedStreak);
  } else {
    streakBox.put('allHabitsCompletedStreak', 0);
  }
}
