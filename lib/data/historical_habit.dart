import 'package:hive/hive.dart';

part 'historical_habit.g.dart';

@HiveType(typeId: 3)
class HistoricalHabit extends HiveObject {
  HistoricalHabit({required this.date, required this.data});

  @HiveField(0)
  DateTime date;

  @HiveField(1)
  List<HistoricalHabitData> data;
}

@HiveType(typeId: 4)
class HistoricalHabitData {
  final String name;
  bool completed;
  final String icon;
  final String category;
  final int amount;
  int amountCompleted;
  final String amountName;
  final int duration;
  int durationCompleted;
  bool skipped;

  HistoricalHabitData({
    required this.name,
    required this.completed,
    required this.icon,
    required this.category,
    required this.amount,
    required this.amountCompleted,
    required this.amountName,
    required this.duration,
    required this.durationCompleted,
    required this.skipped,
  });
}
