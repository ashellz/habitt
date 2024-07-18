import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:hive/hive.dart';

Future<void> fillKeys() async {
  if (!boolBox.containsKey("displayEmptyCategories")) {
    boolBox.put("displayEmptyCategories", false);
  }

  if (!streakBox.containsKey('lastOpenedDay')) {
    streakBox.put(
      'lastOpenedDay',
      DateTime.now().day,
    );
  }
  if (!streakBox.containsKey('lastOpenedMonth')) {
    streakBox.put(
      'lastOpenedMonth',
      DateTime.now().month,
    );
  }
  if (!streakBox.containsKey('allHabitsCompletedStreak')) {
    streakBox.put('allHabitsCompletedStreak', 0);
  }
  if (!boolBox.containsKey('morningNotification')) {
    boolBox.put('morningNotification', false);
  }
  if (!boolBox.containsKey('afternoonNotification')) {
    boolBox.put('afternoonNotification', false);
  }
  if (!boolBox.containsKey('eveningNotification')) {
    boolBox.put('eveningNotification', false);
  }
  if (!boolBox.containsKey('dailyNotification')) {
    boolBox.put('dailyNotification', true);
  }
  if (!boolBox.containsKey('hasNotificationAccess')) {
    boolBox.put('hasNotificationAccess', false);
  }

  if (boolBox.get("isGuest") == null) {
    boolBox.put("isGuest", false);
  }

  if (boolBox.get("isLoggenIn") == null) {
    boolBox.put("isLoggenIn", false);
  }

  if (Hive.box<HabitData>('habits').isEmpty) {
    await Hive.box<HabitData>('habits').add(HabitData(
        name: "Add new habits",
        completed: false,
        icon: "Icons.add",
        category: "Any time",
        streak: 0,
        amount: 2,
        amountName: "habits",
        amountCompleted: 0,
        duration: 0,
        durationCompleted: 0));
    await Hive.box<HabitData>('habits').add(HabitData(
        name: "Open the app",
        completed: true,
        icon: "Icons.door_front_door",
        category: "Any time",
        streak: 0,
        amount: 1,
        amountName: "times",
        amountCompleted: 1,
        duration: 0,
        durationCompleted: 0));
  }
}
