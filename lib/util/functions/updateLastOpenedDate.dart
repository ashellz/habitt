import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restart_app/restart_app.dart';

final streakBox = Hive.box<int>('streak');
final habitBox = Hive.box<HabitData>('habits');

bool newMonth = false;

void updateLastOpenedDate() async {
  DateTime now = DateTime.now();
  int month = now.month;
  int day = now.day;
  int lastOpenedDate = streakBox.get('lastOpenedDay') ?? 0;
  int daysDifference = day - lastOpenedDate;

  if (month != streakBox.get('lastOpenedMonth')) {
    newMonth = true;
  }

  await streakBox.put('lastOpenedDay', day);
  await streakBox.put('lastOpenedMonth', month);

  if (daysDifference > 0 || daysDifference < 0) {
    if (!newMonth) {
      resetOrUpdateStreaks(daysDifference);
    } else {
      if (day == 1) {
        resetOrUpdateStreaks(1);
      } else {
        resetOrUpdateStreaks(2);
      }
    }
    await backupHiveBoxesToFirebase(userId);
    Restart.restartApp();
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
