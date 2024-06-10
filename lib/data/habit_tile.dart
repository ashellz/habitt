import 'package:hive/hive.dart';

part 'habit_tile.g.dart';

@HiveType(typeId: 1)
class HabitData extends HiveObject {
  HabitData(
      {required this.name,
      required this.completed,
      required this.icon,
      required this.category,
      required this.streak});
  @HiveField(0)
  String name;

  @HiveField(1)
  bool completed;

  @HiveField(2)
  String icon;

  @HiveField(3)
  String category;

  @HiveField(4)
  int streak;
}
