import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HabitDataAdapter());

  await Hive.openBox<HabitData>('habits');

  if (Hive.box<HabitData>('habits').isEmpty) {
    await Hive.box<HabitData>('habits').add(HabitData(
        name: "Add a new habit",
        completed: false,
        icon: "Icons.add",
        category: "Any time"));
    await Hive.box<HabitData>('habits').add(HabitData(
        name: "Open the app",
        completed: true,
        icon: "Icons.door_front_door",
        category: "Any time"));
  }

  runApp(const MyApp());
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
