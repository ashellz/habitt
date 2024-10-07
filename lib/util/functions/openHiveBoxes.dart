import 'package:flutter/foundation.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/data/tags.dart';
import 'package:hive/hive.dart';

Future<void> openHiveBoxes() async {
  if (!Hive.isBoxOpen('habits')) {
    if (kDebugMode) {
      print("Opening 'habits' box...");
    }
    await Hive.openBox<HabitData>('habits');
  }
  if (!Hive.isBoxOpen('metadata')) {
    if (kDebugMode) {
      print("Opening 'metadata' box...");
    }
    await Hive.openBox<DateTime>('metadata');
  }
  if (!Hive.isBoxOpen('streak')) {
    if (kDebugMode) {
      print("Opening 'streak' box...");
    }
    await Hive.openBox<int>('streak'); // wont need to upload after first time
  }
  if (!Hive.isBoxOpen('bool')) {
    if (kDebugMode) {
      print("Opening 'bool' box...");
    }
    await Hive.openBox<bool>('bool'); // wont need to upload after first time
  }
  if (!Hive.isBoxOpen('string')) {
    if (kDebugMode) {
      print("Opening 'string' box...");
    }
    await Hive.openBox<String>(
        'string'); // wont need to upload after first time
  }
  if (!Hive.isBoxOpen('list')) {
    if (kDebugMode) {
      print("Opening 'list' box...");
    }
    await Hive.openBox<List>('list'); // wont need to upload after first time
  }
  if (!Hive.isBoxOpen('tags')) {
    if (kDebugMode) {
      print("Opening 'tags' box...");
    }
    await Hive.openBox<TagData>('tags');
  }
  if (!Hive.isBoxOpen('historicalHabits')) {
    if (kDebugMode) {
      print("Opening 'historicalHabits' box...");
    }
    await Hive.openBox<HistoricalHabit>('historicalHabits');
    await Hive.openBox<HistoricalHabitData>('historicalHabitData');
  }
}

Future<void> closeHiveBoxes() async {
  if (Hive.isBoxOpen('habits')) {
    if (kDebugMode) {
      print("Closing 'habits' box...");
    }
    await Hive.box('habits').close();
  }
  if (Hive.isBoxOpen('metadata')) {
    if (kDebugMode) {
      print("Closing 'metadata' box...");
    }
    await Hive.box('metadata').close();
  }
  if (Hive.isBoxOpen('streak')) {
    if (kDebugMode) {
      print("Closing 'streak' box...");
    }
    await Hive.box('streak').close();
  }
  if (Hive.isBoxOpen('bool')) {
    if (kDebugMode) {
      print("Closing 'bool' box...");
    }
    await Hive.box('bool').close();
  }
  if (Hive.isBoxOpen('string')) {
    if (kDebugMode) {
      print("Closing 'string' and 'list' box...");
    }
    await Hive.box('string').close();
    await Hive.box('list').close();
  }

  if (Hive.isBoxOpen('tags')) {
    if (kDebugMode) {
      print("Closing 'tags' box...");
    }
    await Hive.box('tags').close();
  }

  if (Hive.isBoxOpen('historicalHabits')) {
    if (kDebugMode) {
      print("Closing 'historicalHabits' box...");
    }
    await Hive.box('historicalHabits').close();
    await Hive.box('historicalHabitData').close();
  }
}

Future<void> reloadHiveBoxes() async {
  await closeHiveBoxes();
  await openHiveBoxes();
}
