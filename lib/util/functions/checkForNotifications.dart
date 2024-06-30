import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:habit_tracker/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void checkForNotifications() async {
  var notificationBox = Hive.box('notifications');

  DateTime now = DateTime.now();
  print("Hour: ${now.hour}");

  if (notificationBox.get('morningNotification') == true &&
      now.hour == 7 &&
      morningHasHabits == true) {
    triggerMorningNotification();
  } else if (notificationBox.get('afternoonNotification') == true &&
      now.hour == 14 &&
      afternoonHasHabits == true) {
    triggerAfternoonNotification();
  } else if (notificationBox.get('eveningNotification') == true &&
      now.hour == 21 &&
      eveningHasHabits == true) {
    triggerEveningNotification();
  } else if (notificationBox.get('dailyNotification') == true &&
      now.hour == 19) {
    triggerReminderNotification();
  }
}

void triggerMorningNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Morning Habits',
      body: "Good morning! Time to start your day!",
    ),
  );
}

void triggerAfternoonNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Afternoon Habits',
      body: "Good afternoon! Don't forget about your habits!",
    ),
  );
}

void triggerEveningNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Evening Habits',
      body: "Good evening! Time to wind down.",
    ),
  );
}

void triggerReminderNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Check your habits',
      body: "It's 7 PM! Daily check-in time.",
    ),
  );
}
