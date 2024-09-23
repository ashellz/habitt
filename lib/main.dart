import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/data/habit_data.dart';
import 'package:habit_tracker/data/historical_habit.dart';
import 'package:habit_tracker/data/tags.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/onboarding/onboarding_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/services/provider/historical_habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/functions/checkForNotifications.dart';
import 'package:habit_tracker/util/functions/fillKeys.dart';
import 'package:habit_tracker/util/functions/habit/saveHabits.dart';
import 'package:habit_tracker/util/functions/hiveBoxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

bool morningHasHabits = false;
bool afternoonHasHabits = false;
bool eveningHasHabits = false;
bool anytimeHasHabits = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

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
  Hive.registerAdapter(TagDataAdapter());
  Hive.registerAdapter(HistoricalHabitAdapter());
  Hive.registerAdapter(HistoricalHabitDataAdapter());

  await openHiveBoxes();
  await fillKeys();

  saveHabitsForToday();

  checkForNotifications();

  // checking for notification access
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      boolBox.put('hasNotificationAccess', false);
    } else {
      boolBox.put('hasNotificationAccess', true);
    }
  });

  // checking for battery optimization
  bool? isBatteryOptimizationDisabled =
      await DisableBatteryOptimization.isBatteryOptimizationDisabled;
  if (isBatteryOptimizationDisabled == false) {
    await boolBox.put('disabledBatteryOptimization', false);
  } else {
    await boolBox.put('disabledBatteryOptimization', true);
  }

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "1",
    "simplePeriodicTask",
    frequency: const Duration(minutes: 15),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitProvider()),
        ChangeNotifierProvider(create: (context) => HistoricalHabitProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
void callbackDispatcher(BuildContext context) {
  Workmanager().executeTask((task, inputData) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().chooseMainCategory();
      context.read<HabitProvider>().chooseTimeBasedText();
    });

    if (task == "updateDateTask") {
      context.read<HabitProvider>().updateLastOpenedDate();
    }

    saveHabitsForToday();
    checkForNotifications();
    return Future.value(true);
  });
}

hasHabits() {
  final habitBox = Hive.box<HabitData>('habits');
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

void scheduleMidnightTask() {
  final now = DateTime.now();
  final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0);
  final initialDelay = nextMidnight.difference(now);

  Workmanager().registerOneOffTask(
    "1",
    "updateDateTask",
    initialDelay: initialDelay,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        colorScheme: ColorScheme.fromSeed(seedColor: theLightColor),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: theLightColor,
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700),
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              fontFamily: 'Poppins',
            ),
      ),
      home: const AuthCheck(),
      routes: {
        "/home": (_) => const HomePage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<HabitProvider>().chooseMainCategory();
            context.read<HabitProvider>().updateMainCategoryHeight();
            context.read<HistoricalHabitProvider>().calculateStreak(context);
            context.read<HabitProvider>().chooseTimeBasedText();
            context.read<HabitProvider>().updateLastOpenedDate();
          });
          saveHabitsForToday();
          scheduleMidnightTask();

          if (boolBox.containsKey("firstTimeOpened")) {
            if (boolBox.get("firstTimeOpened")!) {
              boolBox.put("firstTimeOpened", false);
              return const OnboardingPage();
            } else {
              return const HomePage();
            }
          } else {
            return const HomePage();
          }
        } else {
          return LoginPage();
        }
      },
    );
  }
}
