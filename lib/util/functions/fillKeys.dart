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
  if (!notificationsBox.containsKey('morningNotification')) {
    notificationsBox.put('morningNotification', false);
  }
  if (!notificationsBox.containsKey('afternoonNotification')) {
    notificationsBox.put('afternoonNotification', false);
  }
  if (!notificationsBox.containsKey('eveningNotification')) {
    notificationsBox.put('eveningNotification', false);
  }
  if (!notificationsBox.containsKey('dailyNotification')) {
    notificationsBox.put('dailyNotification', true);
  }
  if (!notificationsBox.containsKey('hasNotificationAccess')) {
    notificationsBox.put('hasNotificationAccess', false);
  }
}
