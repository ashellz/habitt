import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:habit_tracker/pages/new_home_page.dart';

void checkForNotifications() async {
  checkForCustomNotifications();

  List oneMoreNotificationTexts = [
    "You're crushing it! Just one more habit to go!",
  ];

  List morningNotificationTexts = [];
  List afternoonNotificationTexts = [];
  List eveningNotificationTexts = [];
  List dailyNotificationTexts = [];

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

void checkForCustomNotifications() async {
  List<String> customNotificationTextsNeutral = [
    "Hey there! Don't forget to complete your habit!",
    "Reminder: It's time to work on your habit!",
    "Don't miss out! Make sure to complete your habit today!",
    "Friendly reminder: Don't forget to complete your habit!",
    "It's that time again! Don't forget to do your habit!",
    "Stay on track! Remember to complete your habit!",
    "A little nudge to complete your habit today!",
    "Time to focus on your habit! You've got this!",
    "Don't forget to make time for your habit today!"
  ];

  List<String> customNotificationTextsGood = [
    "Keep the momentum going and finish your habit for today!",
    "You're doing great! Just a reminder to complete your habit!",
    "Keep it up! Don't forget your habit!",
    "Amazing job today! Don't forget to complete your habit!",
    "You're on a roll! Finish your habit and keep the streak alive!",
    "Fantastic work so far! Don't forget your habit!",
    "Keep up the awesome effort! Complete your habit today!",
    "You're a star! Don't forget to complete your habit!",
    "Excellent progress! Just a little more to finish your habit!",
    "You’re doing wonderfully! Finish up your habit for today!"
  ];

  List<String> customNotificationTextsBad = [
    "Don't let yourself down and finish your habit for today!",
    "You can do better than that. Go complete your habit!",
    "Let's get back on track! Complete your habit today!",
    "You’ve got this! Don't miss out on your habit today!",
    "No excuses! Finish your habit and feel accomplished!",
    "Push through and complete your habit today!",
    "Don't give up! Finish your habit and make yourself proud!",
    "Keep trying! You can complete your habit today!",
    "Don't let today slip away! Finish your habit!",
    "Stay motivated! Get your habit done today!"
  ];

  List<String> customNotificationTexts = [];

  checkCustomNotificationTexts(
      customNotificationTexts,
      customNotificationTextsGood,
      customNotificationTextsBad,
      customNotificationTextsNeutral);

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)!.notifications != []) {
      for (int j = 0; j < habitBox.getAt(i)!.notifications.length; j++) {
        if (!habitBox.getAt(i)!.completed) {
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
                body: customNotificationTexts[
                    Random().nextInt(customNotificationTexts.length)],
              ));
        } else {
          await AwesomeNotifications().cancel(i);
        }
      }
    } else {
      await AwesomeNotifications().cancel(i);
    }
  }
}

// checks if you have any completed habits to praise you or to motivate you
void checkCustomNotificationTexts(texts, good, bad, neutral) {
  bool good = false;
  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)!.completed) {
      good = true;
      break;
    }
  }

  if (good) {
    texts = good;
  } else {
    texts = bad;
  }

  texts.addAll(neutral);
}
