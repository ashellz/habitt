import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/data/tags.dart';
import 'package:habitt/firebase_options.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/onboarding/onboarding_page.dart';
import 'package:habitt/services/provider/allhabits_provider.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:habitt/services/provider/language_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/checkForNotifications.dart';
import 'package:habitt/util/functions/fillKeys.dart';
import 'package:habitt/util/functions/habit/saveHabitsForToday.dart';
import 'package:habitt/util/functions/openHiveBoxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

bool doOnce = true;
final FlutterLocalization localization = FlutterLocalization.instance;

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

  localization.init(
    mapLocales: [
      const MapLocale('en', AppLocale.en),
      const MapLocale('ba', AppLocale.ba),
    ],
    initLanguageCode: stringBox.get('language')!,
  );

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
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (context) => AllHabitsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return MaterialApp(
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          title: 'habitt',
          theme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.theLightColor,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                  color: AppColors.theLightColor,
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
          supportedLocales: localization.supportedLocales,
          localizationsDelegates: localization.localizationsDelegates,
          home: const AuthCheck(),
          routes: {
            "/home": (_) => const HomePage(),
          },
        );
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a FutureBuilder to wait for openHiveBoxes to complete
    return FutureBuilder<void>(
      future: openHiveAndPerformTasks(context),
      builder: (context, futureSnapshot) {
        checkForDayJoined(); // After the Future is complete, check for onboarding or homepage
        if (boolBox.containsKey("firstTimeOpened")) {
          if (boolBox.get("firstTimeOpened")!) {
            boolBox.put("firstTimeOpened", false);
            return const OnboardingPage();
          } else {
            return const HomePage();
          }
        } else {
          boolBox.put("firstTimeOpened", false);
          return const OnboardingPage();
        }
      },
    );
  }
}

// Create a function that wraps all necessary tasks
Future<void> openHiveAndPerformTasks(BuildContext context) async {
  // Post-frame callback to update providers and perform actions

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!boolBox.containsKey("update1")) {
      print("wipe");
      boolBox.put("update1", true);

      for (var habit in habitBox.values) {
        habit.type = "Daily";
        habit.weekValue = 1;
        habit.monthValue = 1;
        habit.customValue = 1;
        habit.selectedDaysAWeek = [];
        habit.selectedDaysAMonth = [];

        habit.save();
      }
    }

    if (doOnce) {
      context.read<LanguageProvider>().loadLanguage();
      doOnce = false;
    }
    context.read<DataProvider>().updateHabits(context);
    context.read<DataProvider>().initializeLists(context);
    context.read<HabitProvider>().chooseMainCategory(context);
    context.read<HabitProvider>().updateMainCategoryHeight(context);
    context.read<HistoricalHabitProvider>().calculateStreak(context);
    context.read<HabitProvider>().updateLastOpenedDate(context);
    context.read<DataProvider>().updateHabits(context);
  });

  saveHabitsForToday(context);
  checkForNotifications(context);
}
