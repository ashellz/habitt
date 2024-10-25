import 'package:collection/collection.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/home_page.dart';

void saveHabitsForToday() async {
  DateTime today = DateTime.now();
  List<HistoricalHabitData> habitsForToday = [];
  List<int> todayDate = [today.year, today.month, today.day];

  // Loop through all habits in your habitBox
  for (int i = 0; i < habitBox.length; i++) {
    var habit = habitBox.getAt(i);

    if (habit != null) {
      // Create HistoricalHabitData for each habit
      HistoricalHabitData historicalHabit = HistoricalHabitData(
        name: habit.name,
        completed: habit.completed,
        icon: habit.icon,
        category: habit.category,
        amount: habit.amount,
        amountCompleted: habit.amountCompleted,
        amountName: habit.amountName,
        duration: habit.duration,
        durationCompleted: habit.durationCompleted,
        skipped: habit.skipped,
        id: habit.id,
        task: habit.task,
      );

      // Add the habit data to the list for today
      habitsForToday.add(historicalHabit);
    }
  }

  bool todayExists = false;
  for (int i = 0; i < historicalBox.length; i++) {
    List<int> date = [
      historicalBox.getAt(i)!.date.year,
      historicalBox.getAt(i)!.date.month,
      historicalBox.getAt(i)!.date.day
    ];

    if (const ListEquality().equals(date, todayDate)) {
      todayExists = true;
      historicalBox.getAt(i)!.data.clear();
      historicalBox.getAt(i)!.data.addAll(habitsForToday);
      await historicalBox.getAt(i)!.save();
      break;
    }
  }

  if (!todayExists) {
    await historicalBox.add(HistoricalHabit(date: today, data: habitsForToday));
  }
}
