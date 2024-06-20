import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

void checkForNotifications() {
  var notificationBox = Hive.box('notifications');

  DateTime now = DateTime.now();
  int hour = now.hour;

  if (notificationBox.get('morningNotification') == true && hour == 17) {
    triggerMorningNotification();
  } else if (notificationBox.get('afternoonNotification') == true &&
      hour == 18) {
    triggerAfternoonNotification();
  } else if (notificationBox.get('eveningNotification') == true && hour == 19) {
    triggerEveningNotification();
  } else if (notificationBox.get('dailyNotification') == true && hour == 20) {
    triggerReminderNotification();
  }
}

void triggerMorningNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Morning Habits',
      body: "Hour 17",
    ),
  );
}

void triggerAfternoonNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Afternoon Habits',
      body: "Hour 18",
    ),
  );
}

void triggerEveningNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Evening Habits',
      body: "Hour 19",
    ),
  );
}

void triggerReminderNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'basic_channel',
      title: 'Check your habits',
      body: "Hour 20",
    ),
  );
}
