import 'package:awesome_notifications/awesome_notifications.dart';
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
