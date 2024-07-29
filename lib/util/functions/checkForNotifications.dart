import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:habit_tracker/pages/new_home_page.dart';

void checkForNotifications() async {
  if (boolBox.get("morningNotification") == true) {
    await AwesomeNotifications().createNotification(
        schedule:
            NotificationCalendar(hour: 9, minute: 0, second: 0, repeats: true),
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Morning Habits',
          body:
              "Good morning! 🌞 Time to get started on your morning habits! 💪✨",
        ));
  } else {
    await AwesomeNotifications().cancel(1);
  }
  if (boolBox.get("afternoonNotification") == true) {
    await AwesomeNotifications().createNotification(
        schedule:
            NotificationCalendar(hour: 14, minute: 0, second: 0, repeats: true),
        content: NotificationContent(
          id: 2,
          channelKey: 'basic_channel',
          title: 'Afternoon Habits',
          body: 'Keep the momentum going with your afternoon habits! ☀️',
        ));
  } else {
    await AwesomeNotifications().cancel(2);
  }
  if (boolBox.get("eveningNotification") == true) {
    await AwesomeNotifications().createNotification(
        schedule:
            NotificationCalendar(hour: 21, minute: 0, second: 0, repeats: true),
        content: NotificationContent(
          id: 3,
          channelKey: 'basic_channel',
          title: 'Evening Habits',
          body: 'Finish strong by completing your evening habits! 🌙',
        ));
  } else {
    await AwesomeNotifications().cancel(3);
  }
  if (boolBox.get("dailyNotification") == true) {
    await AwesomeNotifications().createNotification(
        schedule:
            NotificationCalendar(hour: 19, minute: 0, second: 0, repeats: true),
        content: NotificationContent(
          id: 4,
          channelKey: 'basic_channel',
          title: 'Remaining Habits',
          body:
              "It's 7 PM! ⏰ Take a moment to check in and complete your remaining habits! 💪",
        ));
  } else {
    await AwesomeNotifications().cancel(4);
  }
}
