import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/language_provider.dart';
import 'package:provider/provider.dart';

void checkForNotifications(BuildContext context) async {
  checkForCustomNotifications(context);

  scheduleMorningNotification(context);
  scheduleAfternoonNotification(context);
  scheduleEveningNotification(context);
  scheduleDailyNotification(context);
}

void scheduleMorningNotification(BuildContext context) async {
  int morningHabits = 0;
  int morningHabitsCompleted = 0;
  List<HabitData> habitsList =
      Provider.of<DataProvider>(context, listen: false).habitsList;

  List morningNotificationTexts = [];
  List morningNotificationTextsOneLeft = [];
  String languageCode =
      Provider.of<LanguageProvider>(context, listen: false).languageCode;

  if (languageCode == "en") {
    morningNotificationTexts = [
      "Good morning! 🌞 Time to get started on your morning habits! 💪✨",
      "Rise and shine! 🌅 Let's tackle those morning habits! 💥",
      "Morning, superstar! 🌟 Ready to conquer your habits today? 🏆",
      "Wake up and get moving! 🌄 Time to complete your morning habits! 🚀",
      "Start your day right! 🌼 Don't forget your morning habits!",
      "Bright and early! Let's get those morning habits done! 💪",
      "Top of the morning! 🌻 Time to work on your habits! 🏋️",
      "New day, new opportunities! 🌞 Begin with your morning habits! 🔥",
      "Good morning! 🌸 Let's kick off the day with your habits! 💥",
      "It's a fresh start! 🌿 Time to focus on your morning habits! 🏅"
    ];

    morningNotificationTextsOneLeft = [
      "You're crushing it! Just one more habit to go! 💪",
      "Almost there! Just one habit left to complete! 🌞",
      "Great job so far! One more habit to finish your morning! 💪",
      "Keep it up! Just one more habit and you're done! ✨",
      "You're almost done! One more habit to complete your morning! 🌟"
    ];
  } else if (languageCode == "ba") {
    morningNotificationTexts = [
      "Dobro jutro! 🌞 Vrijeme je da započneš svoje jutarnje navike! 💪✨",
      "Ustaj i zablistaj! 🌅 Idemo obaviti te jutarnje navike! 💥",
      "Jutro, zvijezdo! 🌟 Spremna da osvojiš svoje navike danas? 🏆",
      "Probudite se i krenite! 🌄 Vrijeme je da završite svoje jutarnje navike! 🚀",
      "Započni svoj dan kako treba! 🌼 Ne zaboravi svoje jutarnje navike!",
      "Sjajno i rano! Završimo te jutarnje navike! 💪",
      "Dobro jutro! 🌻 Vrijeme je da radiš na svojim navikama! 🏋️",
      "Novi dan, nove prilike! 🌞 Počni sa svojim jutarnjim navikama! 🔥",
      "Dobro jutro! 🌸 Započnimo dan s tvojim navikama! 💥",
      "Svježi početak! 🌿 Vrijeme je da se fokusiraš na svoje jutarnje navike! 🏅"
    ];

    morningNotificationTextsOneLeft = [
      "Odličan posao! Ostala je još samo jedna navika! 💪",
      "Skoro gotovo! Ostala je još jedna navika! 🌞",
      "Sjajno ti ide! Jedna navika te dijeli od završenog jutra! 💪",
      "Samo tako nastavi! Još jedna navika i završio si! ✨",
      "Blizu ste cilja! Jedna navika do završenog jutra! 🌟"
    ];
  }

  if (boolBox.get("morningNotification") == true) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitsList[i].category == "Morning") {
        if (habitsList[i].completed == true) {
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

void scheduleAfternoonNotification(BuildContext context) async {
  int afternoonHabits = 0;
  int afternoonHabitsCompleted = 0;
  List<HabitData> habitsList =
      Provider.of<DataProvider>(context, listen: false).habitsList;

  List afternoonNotificationTexts = [];
  List afternoonNotificationTextsOneLeft = [];

  String languageCode =
      Provider.of<LanguageProvider>(context, listen: false).languageCode;

  if (languageCode == "en") {
    afternoonNotificationTexts = [
      "Keep the momentum going with your afternoon habits!",
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

    afternoonNotificationTextsOneLeft = [
      "You're crushing it! Just one more habit to go! 💪",
      "Almost done! Just one more habit to go this afternoon!",
      "Great job! Only one habit left for the afternoon! 💪",
      "You're doing amazing! Just one more habit this afternoon! 🌞",
      "Keep pushing! One more habit to complete your afternoon! 🔥"
    ];
  } else if (languageCode == "ba") {
    afternoonNotificationTexts = [
      "Nastavi s takvim tempom uz svoje popodnevne navike!",
      "Ostani produktivan! Vrijeme je da radiš na svojim popodnevnim navikama! 💪",
      "Dobar dan! Ne zaboravi svoje navike! 🌞",
      "Iskoristimo ovo popodne! Završiti svoje navike! 🌻",
      "Polovina je dana! Nastavi s navikama! 🚀",
      "Popodnevni poticaj! Vrijeme je da završiš svoje navike! ⚡️",
      "Prevaziđi popodnevni umor! Završiti svoje navike! 🌟",
      "Ostani fokusiran! Popodnevne navike čekaju! 🏆",
      "Učini svoje popodne produktivnim! Radi na svojim navikama! 🔥",
      "Pozitivne vibracije ovo popodne! Ne zaboravi svoje navike! 🌸"
    ];

    afternoonNotificationTextsOneLeft = [
      "Sjajno ti ide! Ostala je još samo jedna navika! 💪",
      "Skoro si završio! Ostala je još samo jedna navika ovo popodne!",
      "Odličan posao! Još samo jedna navika za popodne! 💪",
      "Fantastičan si! Ostala je još samo jedna navika ovo popodne! 🌞",
      "Nastavi dalje! Još jedna navika i tvoje popodne je kompletno! 🔥"
    ];
  }

  if (boolBox.get("afternoonNotification") == true) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitsList[i].category == "Afternoon") {
        if (habitsList[i].completed == true) {
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

void scheduleEveningNotification(BuildContext context) async {
  int eveningHabits = 0;
  int eveningHabitsCompleted = 0;
  List<HabitData> habitsList =
      Provider.of<DataProvider>(context, listen: false).habitsList;
  List eveningNotificationTexts = [];
  List eveningNotificationTextsOneLeft = [];

  String languageCode =
      Provider.of<LanguageProvider>(context, listen: false).languageCode;

  if (languageCode == "en") {
    eveningNotificationTexts = [
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

    eveningNotificationTextsOneLeft = [
      "You're crushing it! Just one more habit to go! 💪",
      "You're nearly there! Just one more habit this evening! 🌙",
      "Finish strong! One more habit to complete tonight! 🌟",
      "Almost finished! Just one habit left for the evening! ✨",
      "End your day right! One more habit to go! 🌌"
    ];
  } else if (languageCode == "ba") {
    eveningNotificationTexts = [
      "Završi dan snažno dovršavajući svoje večernje navike! 🌙",
      "Zaokruži svoj dan uz svoje večernje navike! 🌇",
      "Večer je stigla! Vrijeme je da završiš svoje navike! 🌜",
      "Kompletiraj svoj dan završavajući svoje navike! 🌟",
      "Večernji podsjetnik! Ne zaboravi svoje navike! ✨",
      "Završi dan na pozitivan način uz svoje navike! 🌌",
      "Dobro veče! Vrijeme je da označiš svoje navike kao završene! 🌃",
      "Vrijeme za večernju rutinu! Dovrši svoje navike! 🌠",
      "Završi dan kako treba dovršavajući svoje navike! 🌙",
      "Večernji uspjeh počinje završavanjem tvojih navika! 🌆"
    ];

    eveningNotificationTextsOneLeft = [
      "Odličan si! Ostala je još samo jedna navika! 💪",
      "Skoro si gotov! Ostala je još samo jedna navika večeras! 🌙",
      "Završi snažno! Još jedna navika da zaključiš noć! 🌟",
      "Gotovo si završio! Još jedna navika za večeras! ✨",
      "Završi dan kako treba! Ostala je još samo jedna navika! 🌌"
    ];
  }

  if (boolBox.get("eveningNotification") == true) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitsList[i].category == "Evening") {
        if (habitsList[i].completed == true) {
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

void scheduleDailyNotification(BuildContext context) async {
  int dailyHabits = 0;
  int dailyHabitsCompleted = 0;
  List dailyNotificationTime = listBox.get("dailyNotificationTime")!;
  int hour = dailyNotificationTime[0];
  List<HabitData> habitsList =
      Provider.of<DataProvider>(context, listen: false).habitsList;
  List dailyNotificationTexts = [];
  List dailyNotificationTextsOneLeft = [];
  String languageCode =
      Provider.of<LanguageProvider>(context, listen: false).languageCode;
  String hourSufix = "o'clock";

  if (languageCode == "ba" && !boolBox.get("12hourFormat")!) {
    hourSufix = "sati";
  }

  if (boolBox.get("12hourFormat")!) {
    hourSufix = hour > 12 ? "PM" : "AM";
  }

  if (languageCode == "en") {
    dailyNotificationTexts = [
      "It's $hour $hourSufix! ⏰ A quick check-in to remind you to complete your daily habits! 💪",
      "Reminder at $hour $hourSufix! Stay focused and get your daily habits done! 🌟",
      "It's $hour $hourSufix! Keep up the momentum and work on your daily habits! 💥",
      "Don't forget! It's $hour $hourSufix and a great time to make progress on your habits! 🚀",
      "$hour $hourSufix reminder! A little nudge to help you complete your habits for the day! 💪",
      "At $hour $hourSufix, it's a good idea to check in on your daily habits! 🕒",
      "Daily reminder: It's $hour $hourSufix! Take a moment to focus on your habits! 🌱",
      "It's $hour $hourSufix! Don't miss your chance to work on your daily habits! 🌟",
      "Friendly reminder at $hour $hourSufix! Make sure to stay on track with your habits! 💪",
      "Reminder at $hour $hourSufix! Don't forget to complete your habits today! 🚀",
      "It's $hour $hourSufix! Stay on track and work on your daily habits! 💥",
      "$hour $hourSufix reminder! Take a moment to focus on your daily habits! 🌱",
      "It's $hour $hourSufix! A gentle nudge to help you complete your daily habits! 💪",
      "Don't let the time pass! It's $hour $hourSufix, and a great time to focus on your habits! 🕒",
      "Daily reminder at $hour $hourSufix! Keep up with your habits and stay motivated! 🌟",
      "It's $hour $hourSufix! Don't miss out on completing your daily habits! 💪",
      "It's $hour $hourSufix! Take a moment to check in and complete your daily habits! 💪",
      "Reminder at $hour $hourSufix! Time to wrap up your habits for the day! 🌟",
      "It's $hour $hourSufix! A quick reminder to finish your daily habits! 💥",
      "$hour $hourSufix reminder! Make sure to complete your habits for today! 💪",
      "Friendly reminder at $hour $hourSufix! Make sure to wrap up your habits for the day! 💪"
    ];

    dailyNotificationTextsOneLeft = [
      "You're crushing it! Just one more habit to go! 💪",
      "One last push! Just one more habit to complete today! 💪",
      "You're so close! One habit left for the day! 🌅",
      "Finish the day strong! Just one more habit! 🏅",
      "Almost there! One more habit to wrap up your day! 🌟"
    ];
  } else if (languageCode == "ba") {
    dailyNotificationTexts = [
      "Sada je $hour $hourSufix! ⏰ Brzi podsjetnik da završiš svoje dnevne navike! 💪",
      "Podsjetnik u $hour $hourSufix! Ostani fokusiran i obavi svoje dnevne navike! 🌟",
      "Sada je $hour $hourSufix! Nastavi s momentumom i radi na svojim dnevnim navikama! 💥",
      "Ne zaboravi! Sada je $hour $hourSufix, pravo vrijeme da napraviš napredak u svojim navikama! 🚀",
      "$hour $hourSufix podsjetnik! Mali poticaj da završiš svoje navike za danas! 💪",
      "U $hour $hourSufix, idealno je vrijeme da provjeriš svoje dnevne navike! 🕒",
      "Dnevni podsjetnik: Sada je $hour $hourSufix! Odvoji trenutak za svoje navike! 🌱",
      "Sada je $hour $hourSufix! Ne propusti priliku da radiš na svojim dnevnim navikama! 🌟",
      "Prijateljski podsjetnik u $hour $hourSufix! Pobrini se da ostaneš na pravom putu sa svojim navikama! 💪",
      "Podsjetnik u $hour $hourSufix! Ne zaboravi završiti svoje navike danas! 🚀",
      "Sada je $hour $hourSufix! Ostani na pravom putu i radi na svojim dnevnim navikama! 💥",
      "$hour $hourSufix podsjetnik! Odvoji trenutak da se fokusiraš na svoje dnevne navike! 🌱",
      "Sada je $hour $hourSufix! Lagani poticaj da završiš svoje dnevne navike! 💪",
      "Ne dozvoli da vrijeme prođe! Sada je $hour $hourSufix, pravo vrijeme za fokus na svoje navike! 🕒",
      "Dnevni podsjetnik u $hour $hourSufix! Ostani u toku s navikama i motiviraj se! 🌟",
      "Sada je $hour $hourSufix! Ne propusti priliku da završiš svoje dnevne navike! 💪",
      "Sada je $hour $hourSufix! Odvoji trenutak da provjeriš i završiš svoje dnevne navike! 💪",
      "Podsjetnik u $hour $hourSufix! Vrijeme je da završiš svoje navike za danas! 🌟",
      "Sada je $hour $hourSufix! Brzi podsjetnik da završiš svoje dnevne navike! 💥",
      "$hour $hourSufix podsjetnik! Pobrini se da završiš svoje navike za danas! 💪",
      "Prijateljski podsjetnik u $hour $hourSufix! Pobrini se da zaključiš svoje dnevne navike! 💪"
    ];

    dailyNotificationTextsOneLeft = [
      "Sjajno ti ide! Ostala je još samo jedna navika! 💪",
      "Zadnji napor! Ostala je još samo jedna navika za danas! 💪",
      "Veoma si blizu! Još samo jedna navika za danas! 🌅",
      "Završi dan snažno! Još samo jedna navika! 🏅",
      "Skoro gotovo! Ostala je još samo jedna navika za kraj dana! 🌟"
    ];
  }

  if (boolBox.get("dailyNotification") == true) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitsList[i].completed == true) {
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
              title: 'Daily Notification',
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

void checkForCustomNotifications(BuildContext context) async {
  List<String> customNotificationTextsNeutral = [];
  List<String> customNotificationTextsGood = [];
  List<String> customNotificationTextsBad = [];

  String languageCode =
      Provider.of<LanguageProvider>(context, listen: false).languageCode;

  if (languageCode == "en") {
    customNotificationTextsNeutral = [
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

    customNotificationTextsGood = [
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

    customNotificationTextsBad = [
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
  } else {
    customNotificationTextsNeutral = [
      "Hej! Ne zaboravi završiti svoju naviku!",
      "Podsjetnik: Vrijeme je da radiš na svojoj navici!",
      "Ne propusti priliku! Pobrini se da završiš svoju naviku danas!",
      "Prijateljski podsjetnik: Ne zaboravi završiti svoju naviku!",
      "Vrijeme je! Ne zaboravi odraditi svoju naviku!",
      "Sjeti se završiti svoju naviku!",
      "Mali poticaj da završiš svoju naviku danas!",
      "Vrijeme je da se fokusiraš na svoju naviku! Možeš ti to!",
      "Ne zaboravi odvojiti vrijeme za svoju naviku danas!"
    ];

    customNotificationTextsGood = [
      "Nastavi s dobrim tempom i završi svoju naviku za danas!",
      "Odlično te ide! Podsjetnik da završiš svoju naviku!",
      "Samo tako nastavi! Ne zaboravi svoju naviku!",
      "Nevjerovatan posao danas! Ne zaboravi završiti svoju naviku!",
      "Na pravom si putu! Završi svoju naviku i održi kontinuitet!",
      "Fantastičan rad do sada! Ne zaboravi svoju naviku!",
      "Nastavi s odličnim trudom! Završi svoju naviku danas!",
      "Ti si zvijezda! Ne zaboravi završiti svoju naviku!",
      "Izvanredan napredak! Još malo da završiš svoju naviku!",
      "Sjajno te ide! Završi svoju naviku za danas!"
    ];

    customNotificationTextsBad = [
      "Nemoj se razočarati i završi svoju naviku za danas!",
      "Možeš bolje od toga, idi i završi svoju naviku!",
      "Možeš ti to! Ne propusti svoju naviku danas!",
      "Bez izgovora! Trebao bi završiti svoju naviku!",
      "Izdrži i završi svoju naviku danas!",
      "Nemoj odustati! Završi svoju naviku i budi ponosan na sebe!",
      "Pokušaj ponovo! Možeš završiti svoju naviku danas!",
      "Ne dozvoli da ti dan promakne! Završi svoju naviku!",
      "Ostani motivisan! Odradi svoju naviku danas!"
    ];
  }

  List<HabitData> habitsList =
      Provider.of<DataProvider>(context, listen: false).habitsList;

  for (int i = 0; i < habitsList.length; i++) {
    if (habitsList[i].notifications.isNotEmpty) {
      for (int j = 0; j < habitsList[i].notifications.length; j++) {
        if (!habitsList[i].completed) {
          List notificationsList = habitsList[i].notifications[j];
          List<String> customNotificationTexts = [];
          int notificationId = i * 100 + j;

          checkCustomNotificationTexts(
              customNotificationTexts,
              customNotificationTextsGood,
              customNotificationTextsBad,
              customNotificationTextsNeutral,
              i);

          await AwesomeNotifications().cancel(notificationId);
          await AwesomeNotifications().createNotification(
              schedule: NotificationCalendar(
                  hour: notificationsList[0],
                  minute: notificationsList[1],
                  second: 0),
              content: NotificationContent(
                id: notificationId,
                channelKey: 'basic_channel',
                title: habitsList[i].name,
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

void checkCustomNotificationTexts(List<String> texts, List<String> good,
    List<String> bad, List<String> neutral, int index) {
  bool isGood = false;
  bool amountCheck = false;
  bool durationCheck = false;

  HabitData habit = habitBox.getAt(index)!;

  if (habit.amount > 1) {
    amountCheck = true;
  } else if (habit.duration > 0) {
    durationCheck = true;
  }

  if (amountCheck) {
    if (habit.amountCompleted > 0) {
      isGood = true;
    }
  } else if (durationCheck) {
    if (habit.durationCompleted > 0) {
      isGood = true;
    }
  }

  // Clear the original list and add the appropriate texts
  texts.clear();

  if (isGood) {
    texts.addAll(good);
  } else {
    texts.addAll(bad);
  }

  // Add neutral texts to the selected list
  texts.addAll(neutral);
}
