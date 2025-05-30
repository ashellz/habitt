import 'package:habitt/util/functions/habit/getCustomAppearance.dart';
import 'package:hive/hive.dart';

part 'habit_data.g.dart';

@HiveType(typeId: 1)
class HabitData extends HiveObject {
  HabitData({
    required this.name,
    required this.completed,
    required this.icon,
    required this.category,
    required this.streak,
    required this.amount,
    required this.amountName,
    required this.amountCompleted,
    required this.duration,
    required this.durationCompleted,
    required this.skipped,
    required this.tag,
    required this.notifications,
    required this.notes,
    required this.longestStreak,
    required this.id,
    required this.task,
    required this.type,
    required this.weekValue,
    required this.monthValue,
    required this.customValue,
    required this.selectedDaysAWeek,
    required this.selectedDaysAMonth,
    required this.customAppearance,
    required this.timesCompletedThisWeek,
    required this.timesCompletedThisMonth,
    required this.paused,
    required this.lastCustomUpdate,
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
  int streak;

  @HiveField(5)
  int amount;

  @HiveField(6)
  String amountName;

  @HiveField(7)
  int amountCompleted;

  @HiveField(8)
  int duration;

  @HiveField(9)
  int durationCompleted;

  @HiveField(10)
  bool skipped;

  @HiveField(11)
  String tag;

  @HiveField(12)
  List notifications;

  @HiveField(13)
  String notes;

  @HiveField(14)
  int longestStreak;

  @HiveField(15)
  int id;

  @HiveField(16)
  bool task;

  @HiveField(17)
  String type;

  @HiveField(18)
  int weekValue;

  @HiveField(19)
  int monthValue;

  @HiveField(20)
  int customValue;

  @HiveField(21)
  List selectedDaysAWeek;

  @HiveField(22)
  List selectedDaysAMonth;

  @HiveField(23)
  var customAppearance;

  @HiveField(24)
  int timesCompletedThisWeek;

  @HiveField(25)
  int timesCompletedThisMonth;

  @HiveField(26)
  bool paused;

  @HiveField(27)
  DateTime lastCustomUpdate;
}
