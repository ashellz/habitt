import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/new_home_page.dart';

void checkForNotifications() async {
  checkForCustomNotifications();

  scheduleMorningNotification();
  scheduleAfternoonNotification();
  scheduleEveningNotification();
  scheduleDailyNotification();
}

void scheduleMorningNotification() async {
  int morningHabits = 0;
  int morningHabitsCompleted = 0;

  List morningNotificationTexts = [
    "Good morning! 🌞 Time to get started on your morning habits! 💪✨",
    "Rise and shine! 🌅 Let's tackle those morning habits! 💥",
    "Morning, superstar! 🌟 Ready to conquer your habits today? 🏆",
    "Wake up and get moving! 🌄 Time to complete your morning habits! 🚀",
    "Start your day right! 🌼 Don't forget your morning habits!",
    "Bright and early! ☀️ Let's get those morning habits done! 💪",
    "Top of the morning! 🌻 Time to work on your habits! 🏋️",
    "New day, new opportunities! 🌞 Begin with your morning habits! 🔥",
    "Good morning! 🌸 Let's kick off the day with your habits! 💥",
    "It's a fresh start! 🌿 Time to focus on your morning habits! 🏅"
  ];

  List morningNotificationTextsOneLeft = [
    "You're crushing it! Just one more habit to go! 💪",
    "Almost there! Just one habit left to complete! 🌞",
    "Great job so far! One more habit to finish your morning! 💪",
    "Keep it up! Just one more habit and you're done! ✨",
    "You're almost done! One more habit to complete your morning! 🌟"
  ];

  if (boolBox.get("morningNotification") == true) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitBox.getAt(i)?.category == "Morning") {
        if (habitBox.getAt(i)?.completed == true) {
          morningHabitsCompleted++;
        }
        morningHabits++;
      }
    }

    if (morningHabits != 0) {
      if (morningHabitsCompleted != morningHabits) {
        if (morningHabits - morningHabitsCompleted == 1) {
          morningNotificationTexts = morningNotificationTextsOneLeft;
        }

        await AwesomeNotifications().cancel(1111);
        await AwesomeNotifications().createNotification(
            schedule: NotificationCalendar(
                hour: listBox.get("morningNotificationTime")![0],
                minute: listBox.get("morningNotificationTime")![1],
                second: 0,
                repeats: true),
            content: NotificationContent(
              id: 1111,
              channelKey: 'basic_channel',
              title: 'Morning Habits',
              body: morningNotificationTexts[
                  Random().nextInt(morningNotificationTexts.length)],
            ));
      } else {
        await AwesomeNotifications().cancel(1111);
      }
    } else {
      await AwesomeNotifications().cancel(1111);
    }
  } else {
    await AwesomeNotifications().cancel(1111);
  }
}

void scheduleAfternoonNotification() async {
  int afternoonHabits = 0;
  int afternoonHabitsCompleted = 0;

  List afternoonNotificationTexts = [
    "Keep the momentum going with your afternoon habits! ☀️",
    "Stay productive! Time to work on your afternoon habits! 💪",
    "Good afternoon! Don't forget your habits! 🌞",
    "Let's make this afternoon count! Finish your habits! 🌻",
    "Halfway through the day! Keep up with your habits! 🚀",
    "Afternoon boost! Time to complete your habits! ⚡️",
    "Push through the afternoon slump! Finish your habits! 🌟",
    "Stay focused! Afternoon habits are waiting! 🏆",
    "Make your afternoon productive! Work on your habits! 🔥",
    "Good vibes this afternoon! Don’t forget your habits! 🌸"
  ];

  List afternoonNotificationTextsOneLeft = [
    "You're crushing it! Just one more habit to go! 💪",
    "Almost done! Just one more habit to go this afternoon! ☀️",
    "Great job! Only one habit left for the afternoon! 💪",
    "You're doing amazing! Just one more habit this afternoon! 🌞",
    "Keep pushing! One more habit to complete your afternoon! 🔥"
  ];

  if (boolBox.get("afternoonNotification") == true) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitBox.getAt(i)?.category == "Afternoon") {
        if (habitBox.getAt(i)?.completed == true) {
          afternoonHabitsCompleted++;
        }
        afternoonHabits++;
      }
    }

    if (afternoonHabits != 0) {
      if (afternoonHabitsCompleted != afternoonHabits) {
        if (afternoonHabits - afternoonHabitsCompleted == 1) {
          afternoonNotificationTexts = afternoonNotificationTextsOneLeft;
        }

        await AwesomeNotifications().cancel(2222);
        await AwesomeNotifications().createNotification(
            schedule: NotificationCalendar(
                hour: listBox.get("afternoonNotificationTime")![0],
                minute: listBox.get("afternoonNotificationTime")![1],
                second: 0,
                repeats: true),
            content: NotificationContent(
              id: 2222,
              channelKey: 'basic_channel',
              title: 'Afternoon Habits',
              body: afternoonNotificationTexts[
                  Random().nextInt(afternoonNotificationTexts.length)],
            ));
      } else {
        await AwesomeNotifications().cancel(2222);
      }
    } else {
      await AwesomeNotifications().cancel(2222);
    }
  } else {
    await AwesomeNotifications().cancel(2222);
  }
}

void scheduleEveningNotification() async {
  int eveningHabits = 0;
  int eveningHabitsCompleted = 0;

  List eveningNotificationTexts = [
    "Finish strong by completing your evening habits! 🌙",
    "Wrap up your day with your evening habits! 🌇",
    "Evening is here! Time to complete your habits! 🌜",
    "Wind down your day by finishing your habits! 🌟",
    "Evening reminder! Don't forget your habits! ✨",
    "End your day on a high note with your habits! 🌌",
    "Good evening! Time to check off your habits! 🌃",
    "Evening routine time! Complete your habits! 🌠",
    "Finish the day right by completing your habits! 🌙",
    "Evening success starts with finishing your habits! 🌆"
  ];

  List eveningNotificationTextsOneLeft = [
    "You're crushing it! Just one more habit to go! 💪",
    "You're nearly there! Just one more habit this evening! 🌙",
    "Finish strong! One more habit to complete tonight! 🌟",
    "Almost finished! Just one habit left for the evening! ✨",
    "End your day right! One more habit to go! 🌌"
  ];

  if (boolBox.get("eveningNotification") == true) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitBox.getAt(i)?.category == "Evening") {
        if (habitBox.getAt(i)?.completed == true) {
          eveningHabitsCompleted++;
        }
        eveningHabits++;
      }
    }

    if (eveningHabits != 0) {
      if (eveningHabitsCompleted != eveningHabits) {
        if (eveningHabits - eveningHabitsCompleted == 1) {
          eveningNotificationTexts = eveningNotificationTextsOneLeft;
        }

        await AwesomeNotifications().cancel(3333);
        await AwesomeNotifications().createNotification(
            schedule: NotificationCalendar(
                hour: listBox.get("eveningNotificationTime")![0],
                minute: listBox.get("eveningNotificationTime")![1],
                second: 0,
                repeats: true),
            content: NotificationContent(
              id: 3333,
              channelKey: 'basic_channel',
              title: 'Evening Habits',
              body: eveningNotificationTexts[
                  Random().nextInt(eveningNotificationTexts.length)],
            ));
      } else {
        await AwesomeNotifications().cancel(3333);
      }
    } else {
      await AwesomeNotifications().cancel(3333);
    }
  } else {
    await AwesomeNotifications().cancel(3333);
  }
}

void scheduleDailyNotification() async {
  int dailyHabits = 0;
  int dailyHabitsCompleted = 0;

  List dailyNotificationTexts = [
    "It's 7 PM! ⏰ Take a moment to check in and complete your remaining habits! 💪",
    "7 PM reminder! Time to wrap up your habits for the day! 🕖",
    "7 PM check-in! Complete your habits before the day ends! 🌇",
    "Don't miss out! Finish your habits before the day ends! 🕢",
    "7 PM and it's habit time! Wrap up your day strong! 💥",
    "Take a moment at 7 PM to check your remaining habits! 🌟",
    "Evening is near! Make sure to finish your habits! 🌙",
    "7 PM habit check! Complete your tasks for the day! 🕖",
    "Daily reminder at 7 PM! Finish your habits strong! 💪"
  ];

  List dailyNotificationTextsOneLeft = [
    "You're crushing it! Just one more habit to go! 💪",
    "One last push! Just one more habit to complete today! 💪",
    "You're so close! One habit left for the day! 🌅",
    "Finish the day strong! Just one more habit! 🏅",
    "Almost there! One more habit to wrap up your day! 🌟"
  ];

  if (boolBox.get("dailyNotification") == true) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitBox.getAt(i)?.completed == true) {
        dailyHabitsCompleted++;
      }
      dailyHabits++;
    }

    if (dailyHabits != 0) {
      if (dailyHabitsCompleted != dailyHabits) {
        if (dailyHabits - dailyHabitsCompleted == 1) {
          dailyNotificationTexts = dailyNotificationTextsOneLeft;
        }

        await AwesomeNotifications().cancel(4444);
        await AwesomeNotifications().createNotification(
            schedule: NotificationCalendar(
                hour: listBox.get("dailyNotificationTime")![0],
                minute: listBox.get("dailyNotificationTime")![1],
                second: 0,
                repeats: true),
            content: NotificationContent(
              id: 4444,
              channelKey: 'basic_channel',
              title: 'Remaining Habits',
              body: dailyNotificationTexts[
                  Random().nextInt(dailyNotificationTexts.length)],
            ));
      } else {
        await AwesomeNotifications().cancel(4444);
      }
    } else {
      await AwesomeNotifications().cancel(4444);
    }
  } else {
    await AwesomeNotifications().cancel(4444);
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

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)!.notifications != []) {
      for (int j = 0; j < habitBox.getAt(i)!.notifications.length; j++) {
        if (!habitBox.getAt(i)!.completed) {
          List notificationsList = habitBox.getAt(i)!.notifications[j];
          List<String> customNotificationTexts = [];

          checkCustomNotificationTexts(
              customNotificationTexts,
              customNotificationTextsGood,
              customNotificationTextsBad,
              customNotificationTextsNeutral,
              i);

          await AwesomeNotifications().cancel(i);
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

void checkCustomNotificationTexts(texts, good, bad, neutral, index) {
  bool good = false;
  bool amountCheck = false;
  bool durationCheck = false;

  HabitData habit = habitBox.getAt(index)!;

  if (habit.amount > 1) {
    amountCheck = true;
  } else if (habit.duration > 0) {
    durationCheck = true;
  }

  if (amountCheck == true) {
    if (habit.amountCompleted > 0) {
      good = true;
    }
  } else if (durationCheck == true) {
    if (habit.durationCompleted > 0) {
      good = true;
    }
  } else {
    texts = neutral;
  }

  if (good) {
    texts = good;
  } else {
    texts = bad;
  }

  if (texts != neutral) {
    texts.addAll(neutral);
  }
}
