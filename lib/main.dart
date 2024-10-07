import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/data/tags.dart';
import 'package:habitt/firebase_options.dart';
import 'package:habitt/pages/auth/login_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/onboarding/onboarding_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/checkForNotifications.dart';
import 'package:habitt/util/functions/fillKeys.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:habitt/util/functions/openHiveBoxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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

  // checking for notification access
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      boolBox.put('hasNotificationAccess', false);
    } else {
      boolBox.put('hasNotificationAccess', true);
    }
  });

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'habitt',
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
          // Create a FutureBuilder to wait for openHiveBoxes to complete
          return FutureBuilder<void>(
            future: openHiveAndPerformTasks(context),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // After the Future is complete, check for onboarding or homepage
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
            },
          );
        } else {
          return LoginPage();
        }
      },
    );
  }

  // Create a function that wraps all necessary tasks
  Future<void> openHiveAndPerformTasks(BuildContext context) async {
    await openHiveBoxes();
    fillKeys();

    // Post-frame callback to update providers and perform actions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().chooseMainCategory();
      context.read<HabitProvider>().updateMainCategoryHeight();
      context.read<HistoricalHabitProvider>().calculateStreak(context);
      context.read<HabitProvider>().chooseTimeBasedText();
      context.read<HabitProvider>().updateLastOpenedDate();
      context.read<HabitProvider>().updateHabits();
    });

    saveHabitsForToday();
    checkForNotifications();
  }
}
