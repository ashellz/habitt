import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/signup_page.dart';
import 'package:habit_tracker/util/functions/fillKeys.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

bool morningHasHabits = false;
bool afternoonHasHabits = false;
bool eveningHasHabits = false;
bool anytimeHasHabits = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        name: "Add new habits",
        completed: false,
        icon: "Icons.add",
        category: "Any time",
        streak: 0,
        amount: 2,
        amountName: "habits",
        amountCompleted: 0,
        duration: 0,
        durationCompleted: 0));
    await Hive.box<HabitData>('habits').add(HabitData(
        name: "Open the app",
        completed: true,
        icon: "Icons.door_front_door",
        category: "Any time",
        streak: 0,
        amount: 1,
        amountName: "times",
        amountCompleted: 1,
        duration: 0,
        durationCompleted: 0));
  }

  hasHabits();
  openCategory();
  fillKeys();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "1",
    "simplePeriodicTask",
    frequency: const Duration(minutes: 15),
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
    Hive.registerAdapter(HabitDataAdapter());
    await Hive.openBox<HabitData>('habits');
    await hasHabits();
    await Hive.openBox<bool>('notifications');

    var notificationBox = Hive.box('notifications');

    DateTime now = DateTime.now();
    print("Hour: ${now.hour}");

    if (now.hour == 5 && notificationBox.get('morningNotification') == true) {
      if (morningHasHabits == true) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1239,
            channelKey: 'basic_channel',
            title: 'Morning Habits',
            body: "Good morning! Time to start your day!",
          ),
        );
      }
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
      home: SignupPage(),
    );
  }
}
