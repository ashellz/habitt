import 'package:habit_tracker/data/habit_tile.dart';
import 'package:hive/hive.dart';

Future<void> completeHabit(int index) async {
  final habitBox = Hive.box<HabitData>('habits');
  final existingHabit = habitBox.getAt(index);

  if (existingHabit != null) {
    final updatedHabit = HabitData(
      name: existingHabit.name,
      completed: !existingHabit.completed,
      icon: existingHabit.icon,
      category: existingHabit.category,
      streak: existingHabit.streak,
      amount: existingHabit.amount,
      amountName: existingHabit.amountName,
      amountCompleted: !existingHabit.completed ? existingHabit.amount : 0,
      duration: existingHabit.duration,
      durationCompleted: !existingHabit.completed ? existingHabit.duration : 0,
    );

    await habitBox.putAt(index, updatedHabit);
  }
}
