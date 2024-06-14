import 'package:habit_tracker/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void checkForNotifications() {
  var notificationBox = Hive.box('notifications');

  DateTime now = DateTime.now();
  int hour = now.hour;

  if (notificationBox.get('morningNotification') == true &&
      hour == 7 &&
      morningNotification == false &&
      morningHasHabits == true) {
    triggerMorningNotification();
    morningNotification = true;
  } else if (notificationBox.get('afternoonNotification') == true &&
      hour == 15 &&
      afternoonNotification == false &&
      afternoonHasHabits == true) {
    triggerAfternoonNotification();
    afternoonNotification = true;
  } else if (notificationBox.get('eveningNotification') == true &&
      hour == 22 &&
      eveningNotification == false &&
      eveningHasHabits == true) {
    triggerEveningNotification();
  } else if (notificationBox.get('dailyNotification') == true &&
      hour == 19 &&
      dailyNotification == false) {
    triggerReminderNotification();
    dailyNotification = true;
  } else {
    morningNotification = false;
    afternoonNotification = false;
    eveningNotification = false;
    dailyNotification = false;
  }
}
