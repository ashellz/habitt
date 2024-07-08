import 'package:habit_tracker/data/habit_tile.dart';
import 'package:hive/hive.dart';

Future<void> openHiveBoxes() async {
  if (!Hive.isBoxOpen('habits')) {
    await Hive.openBox<HabitData>('habits');
  }
  if (!Hive.isBoxOpen('metadata')) {
    await Hive.openBox<DateTime>('metadata');
  }
  if (!Hive.isBoxOpen('streak')) {
    await Hive.openBox<int>('streak');
  }
  if (!Hive.isBoxOpen('bool')) {
    await Hive.openBox<bool>('bool');
  }
  if (!Hive.isBoxOpen('string')) {
    await Hive.openBox<String>('string');
  }
}

Future<void> closeHiveBoxes() async {
  if (Hive.isBoxOpen('habits')) {
    await Hive.box('habits').close();
  }
  if (Hive.isBoxOpen('metadata')) {
    await Hive.box('metadata').close();
  }
  if (Hive.isBoxOpen('streak')) {
    await Hive.box('streak').close();
  }
  if (Hive.isBoxOpen('bool')) {
    await Hive.box('bool').close();
  }
  if (Hive.isBoxOpen('string')) {
    await Hive.box('string').close();
  }
}
