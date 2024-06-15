import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:habit_tracker/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void checkForNotifications() {
  var notificationBox = Hive.box('notifications');

  DateTime now = DateTime.now();
  int hour = now.hour;

  if (notificationBox.get('morningNotification') == true &&
      hour == 7 &&
      morningHasHabits == true) {
    triggerMorningNotification();
    morningNotification = true;
  } else if (notificationBox.get('afternoonNotification') == true &&
      hour == 14 &&
      afternoonHasHabits == true) {
    triggerAfternoonNotification();
    afternoonNotification = true;
  } else if (notificationBox.get('eveningNotification') == true &&
      hour == 22 &&
      eveningHasHabits == true) {
    triggerEveningNotification();
  } else if (notificationBox.get('dailyNotification') == true && hour == 19) {
    triggerReminderNotification();
    dailyNotification = true;
  }
}

void triggerMorningNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Morning Habits',
      body: "Good morning! Time to start your day!",
    ),
  );
}

void triggerAfternoonNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Afternoon Habits',
      body: "Good afternoon! Don't forget about your habits!",
    ),
  );
}

void triggerEveningNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Evening Habits',
      body: "Good evening! Time to wind down.",
    ),
  );
}

void triggerReminderNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Check your habits',
      body: "It's 7 PM! Daily check-in time.",
    ),
  );
}
