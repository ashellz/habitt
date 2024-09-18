import 'package:habit_tracker/data/habit_data.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

final streakBox = Hive.box<int>('streak');
final habitBox = Hive.box<HabitData>('habits');

void updateLastOpenedDate() async {
  DateTime now = DateTime.now();
  int day = now.day;
  int lastOpenedDate = streakBox.get('lastOpenedDay') ?? 0;
  int daysDifference = day - lastOpenedDate;

  await streakBox.put('lastOpenedDay', day);

  if (daysDifference > 0 || daysDifference < 0) {
    resetCompletionStatus();

    if (userId != null) {
      await backupHiveBoxesToFirebase(userId);
    }
  }
}

void resetCompletionStatus() {
  for (int i = 0; i < habitBox.length; i++) {
    var habit = habitBox.getAt(i)!;
    habit.amountCompleted = 0;
    habit.durationCompleted = 0;
    habit.completed = false;
    habit.skipped = false;
    habit.save();
  }
}

void resetOrUpdateStreaks(int daysDifference) {
  bool allHabitsCompleted = true;
  bool skipAllHabitsCompleted = false;
  for (int i = 0; i < habitBox.length; i++) {
    var habit = habitBox.getAt(i)!;
    if (daysDifference == 1) {
      if (habit.completed) {
        if (!habit.skipped) {
          habit.streak += 1;
        } else {
          skipAllHabitsCompleted = true;
        }
      } else {
        allHabitsCompleted = false;
        habit.streak = 0;
      }
    } else {
      allHabitsCompleted = false;
      habit.streak = 0;
    }
    habit.amountCompleted = 0;
    habit.durationCompleted = 0;
    habit.completed = false;
    habit.skipped = false;
    habit.save();
  }

  int allHabitsCompletedStreak = streakBox.get('allHabitsCompletedStreak') ?? 0;

  if (allHabitsCompleted) {
    if (!skipAllHabitsCompleted) {
      allHabitsCompletedStreak += 1;
      streakBox.put('allHabitsCompletedStreak', allHabitsCompletedStreak);
    }
  } else {
    streakBox.put('allHabitsCompletedStreak', 0);
  }
}
