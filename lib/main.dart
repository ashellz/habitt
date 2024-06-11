import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';

bool morningHasHabits = false;
bool afternoonHasHabits = false;
bool eveningHasHabits = false;
bool anytimeHasHabits = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://drawable/notification2',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color.fromARGB(255, 37, 67, 54),
      ),
    ],
  );
  await Hive.initFlutter();
  Hive.registerAdapter(HabitDataAdapter());

  await Hive.openBox<HabitData>('habits');
  await Hive.openBox<DateTime>('metadata');
  await Hive.openBox<int>('streak');
  await Hive.openBox<bool>('notifications');

  if (Hive.box<HabitData>('habits').isEmpty) {
    await Hive.box<HabitData>('habits').add(HabitData(
        name: "Add a new habit",
        completed: false,
        icon: "Icons.add",
        category: "Any time",
        streak: 0));
    await Hive.box<HabitData>('habits').add(HabitData(
        name: "Open the app",
        completed: true,
        icon: "Icons.door_front_door",
        category: "Any time",
        streak: 0));
  }

  hasHabits();

  openCategory();

  if (!streakBox.containsKey('allHabitsCompletedStreak')) {
    streakBox.put('allHabitsCompletedStreak', 0);
  }
  if (!notificationsBox.containsKey('morningNotification')) {
    notificationsBox.put('morningNotification', false);
  }
  if (!notificationsBox.containsKey('afternoonNotification')) {
    notificationsBox.put('afternoonNotification', false);
  }
  if (!notificationsBox.containsKey('eveningNotification')) {
    notificationsBox.put('eveningNotification', false);
  }
  if (!notificationsBox.containsKey('dailyNotification')) {
    notificationsBox.put('dailyNotification', true);
  }
  if (!notificationsBox.containsKey('hasNotificationAccess')) {
    notificationsBox.put('hasNotificationAccess', false);
  }

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "1",
    "simplePeriodicTask",
    frequency: const Duration(minutes: 31),
  );

  runApp(const MyApp());
}

bool morningNotification = false;
bool afternoonNotification = false;
bool eveningNotification = false;
bool dailyNotification = false;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();

    hasHabits();

    var notificationBox = await Hive.openBox('notifications');

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

    if (hour == 0) {
      updateStreaks();
    }

    return Future.value(true);
  });
}

void openCategory() {
  if (morningHasHabits == true) {
    morningVisible = true;
    for (int i = 0; i < Hive.box<HabitData>('habits').length; i++) {
      if (habitBox.getAt(i)?.category == 'Morning') {
        morningHeight += 82;
      }
    }
  }
  if (afternoonHasHabits == true) {
    afternoonVisible = true;
    for (int i = 0; i < Hive.box<HabitData>('habits').length; i++) {
      if (habitBox.getAt(i)?.category == 'Afternoon') {
        afternoonHeight += 82;
      }
    }
  }
  if (eveningHasHabits == true) {
    eveningVisible = true;
    for (int i = 0; i < Hive.box<HabitData>('habits').length; i++) {
      if (habitBox.getAt(i)?.category == 'Evening') {
        eveningHeight += 82;
      }
    }
  }
  if (anytimeHasHabits == true) {
    anyTimeVisible = true;
    for (int i = 0; i < Hive.box<HabitData>('habits').length; i++) {
      if (habitBox.getAt(i)?.category == 'Any time') {
        anyTimeHeight += 82;
      }
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700),
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
              fontFamily: 'Poppins',
            ),
      ),
      home: const HomePage(),
    );
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

hasHabits() {
  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)?.category == 'Morning') {
      morningHasHabits = true;
    } else if (habitBox.getAt(i)?.category == 'Afternoon') {
      afternoonHasHabits = true;
    } else if (habitBox.getAt(i)?.category == 'Evening') {
      eveningHasHabits = true;
    } else if (habitBox.getAt(i)?.category == 'Any time') {
      anytimeHasHabits = true;
    }
  }
}

void updateStreaks() {
  bool allHabitsCompleted = true;

  for (int i = 0; i < habitBox.length; i++) {
    var habit = habitBox.getAt(i)!;
    if (habit.completed) {
      habit.streak += 1;
    } else {
      allHabitsCompleted = false;
      habit.streak = 0;
    }
    habit.completed = false;
    habit.save();
  }

  int allHabitsCompletedStreak = streakBox.get('allHabitsCompletedStreak') ?? 0;

  if (allHabitsCompleted) {
    allHabitsCompletedStreak += 1;
    streakBox.put('allHabitsCompletedStreak', allHabitsCompletedStreak);
  } else {
    streakBox.put('allHabitsCompletedStreak', 0);
  }
  streakBox.put('allHabitsCompletedStreak', allHabitsCompletedStreak);
}
