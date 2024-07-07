import 'package:habit_tracker/pages/home_page.dart';

void fillKeys() {
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
}
