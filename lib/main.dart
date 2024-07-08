import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/login_page.dart';
import 'package:habit_tracker/util/functions/fillKeys.dart';
import 'package:habit_tracker/util/functions/hiveBoxes.dart';
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
  await Hive.initFlutter("hive_folder");
  Hive.registerAdapter(HabitDataAdapter());

  await openHiveBoxes();

  hasHabits();
  openCategory();

  await fillKeys();

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
    var notificationBox = Hive.box('bool');

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
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData || boolBox.get("isGuest") == true) {
          return const HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
