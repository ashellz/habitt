import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:habit_tracker/pages/new_home_page.dart';

void checkForNotifications() async {
  /*
  in checkForNotifications() add for loop for checking every habit if it has a
  notification to true, if it does then its gonna go through a for loop in notificationData
  to find all notifications wiht the same id and schedule them for hour and minute
  */

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)!.notifications != []) {
      for (int j = 0; j < habitBox.getAt(i)!.notifications.length; j++) {
        List notificationsList = habitBox.getAt(i)!.notifications[j];
        await AwesomeNotifications().createNotification(
            schedule: NotificationCalendar(
                hour: notificationsList[0],
                minute: notificationsList[1],
                second: 0),
            content: NotificationContent(
              id: i,
              channelKey: 'basic_channel',
              title: habitBox.getAt(i)!.name,
              body: "Hey there! Don't forget to complete your habit!",
            ));
      }
    } else {
      await AwesomeNotifications().cancel(i);
    }
  }

  if (boolBox.get("morningNotification") == true) {
    await AwesomeNotifications().createNotification(
        schedule:
            NotificationCalendar(hour: 9, minute: 0, second: 0, repeats: true),
        content: NotificationContent(
          id: 1111,
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
          id: 2222,
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
          id: 3333,
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
          id: 4444,
          channelKey: 'basic_channel',
          title: 'Remaining Habits',
          body:
              "It's 7 PM! ⏰ Take a moment to check in and complete your remaining habits! 💪",
        ));
  } else {
    await AwesomeNotifications().cancel(4);
  }
}
