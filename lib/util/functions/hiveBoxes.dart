import 'package:habit_tracker/data/habit_tile.dart';
import 'package:hive/hive.dart';

Future<void> openHiveBoxes() async {
  if (!Hive.isBoxOpen('habits')) {
    print("Opening 'habits' box...");
    await Hive.openBox<HabitData>('habits');
  }
  if (!Hive.isBoxOpen('metadata')) {
    print("Opening 'metadata' box...");
    await Hive.openBox<DateTime>('metadata');
  }
  if (!Hive.isBoxOpen('streak')) {
    print("Opening 'streak' box...");
    await Hive.openBox<int>('streak'); // wont need to upload after first time
  }
  if (!Hive.isBoxOpen('bool')) {
    print("Opening 'bool' box...");
    await Hive.openBox<bool>('bool'); // wont need to upload after first time
  }
  if (!Hive.isBoxOpen('string')) {
    print("Opening 'string' box...");
    await Hive.openBox<String>(
        'string'); // wont need to upload after first time
  }
}

Future<void> closeHiveBoxes() async {
  if (Hive.isBoxOpen('habits')) {
    print("Closing 'habits' box...");
    await Hive.box('habits').close();
  }
  if (Hive.isBoxOpen('metadata')) {
    print("Closing 'metadata' box...");
    await Hive.box('metadata').close();
  }
  if (Hive.isBoxOpen('streak')) {
    print("Closing 'streak' box...");
    await Hive.box('streak').close();
  }
  if (Hive.isBoxOpen('bool')) {
    print("Closing 'bool' box...");
    await Hive.box('bool').close();
  }
  if (Hive.isBoxOpen('string')) {
    print("Closing 'string' box...");
    await Hive.box('string').close();
  }
}
