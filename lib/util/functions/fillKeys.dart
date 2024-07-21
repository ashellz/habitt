import 'package:habit_tracker/pages/new_home_page.dart';

Future<void> fillKeys() async {
  if (!boolBox.containsKey("firstTimeOpened")) {
    boolBox.put("firstTimeOpened", true);
  }

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
}
