import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';

bool morningHasHabits = false;
bool afternoonHasHabits = false;
bool eveningHasHabits = false;
bool anytimeHasHabits = false;

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HabitDataAdapter());

  await Hive.openBox<HabitData>('habits');
  await Hive.openBox<DateTime>('metadata');

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

  openCategory();

  runApp(const MyApp());
}

void openCategory() {
  if (morningHasHabits == true) {
    morningVisible = true;
    for (int i = 0; i < Hive.box<HabitData>('habits').length; i++) {
      if (habitBox.getAt(i)?.category == 'Morning') {
        morningHeight += 71;
      }
    }
  }
  if (afternoonHasHabits == true) {
    afternoonVisible = true;
    for (int i = 0; i < Hive.box<HabitData>('habits').length; i++) {
      if (habitBox.getAt(i)?.category == 'Afternoon') {
        afternoonHeight += 71;
      }
    }
  }
  if (eveningHasHabits == true) {
    eveningVisible = true;
    for (int i = 0; i < Hive.box<HabitData>('habits').length; i++) {
      if (habitBox.getAt(i)?.category == 'Evening') {
        eveningHeight += 71;
      }
    }
  }
  if (anytimeHasHabits == true) {
    anyTimeVisible = true;
    for (int i = 0; i < Hive.box<HabitData>('habits').length; i++) {
      if (habitBox.getAt(i)?.category == 'Any time') {
        anyTimeHeight += 71;
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
