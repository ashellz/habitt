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
class HistoricalHabitData extends HiveObject {
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
    required this.id,
    required this.task,
    required this.type,
    required this.weekValue,
    required this.monthValue,
    required this.customValue,
    required this.selectedDaysAWeek,
    required this.selectedDaysAMonth,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  bool completed;

  @HiveField(2)
  String icon;

  @HiveField(3)
  String category;

  @HiveField(4)
  int amount;

  @HiveField(5)
  int amountCompleted;

  @HiveField(6)
  String amountName;

  @HiveField(7)
  int duration;

  @HiveField(8)
  int durationCompleted;

  @HiveField(9)
  bool skipped;

  @HiveField(10)
  int id;

  @HiveField(11)
  bool task;

  @HiveField(12)
  String type;

  @HiveField(13)
  int weekValue;

  @HiveField(14)
  int monthValue;

  @HiveField(15)
  int customValue;

  @HiveField(16)
  List selectedDaysAWeek;

  @HiveField(17)
  List selectedDaysAMonth;
}
