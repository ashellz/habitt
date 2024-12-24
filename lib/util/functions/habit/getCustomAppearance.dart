import 'package:habitt/data/habit_data.dart';
import 'package:habitt/util/functions/getSortedHistoricalList.dart';
import 'package:habitt/util/functions/habit/getHabitFromId.dart';

List<DateTime> getCustomAppearance(int id) {
  List<DateTime> customAppearance = [];
  HabitData habit = getHabitFromId(id);
  DateTime? habitFoundAtDate;
  bool shouldBreak = false;

  var historicalHabits = getSortedHistoricalList();

  for (int i = 0; i < historicalHabits.length; i++) {
    if (i == 30) {
      break;
    }

    for (int j = 0; j < historicalHabits[i].data.length; j++) {
      if (historicalHabits[i].data[j].id == habit.id) {
        habitFoundAtDate = historicalHabits[i].date;
        shouldBreak = true;
        break;
      }
    }

    if (shouldBreak) {
      break;
    }
  }

  if (habitFoundAtDate != null) {
    int counter = 0;
    DateTime day = habitFoundAtDate;

    for (int i = 0; i < 30; i++) {
      if (counter % habit.customValue == 0) {
        customAppearance.add(day);
      }
      day = day.add(const Duration(days: 1));
      counter++;
    }
  } else {
    int counter = 0;
    DateTime day = DateTime.now();

    for (int i = 0; i < 30; i++) {
      if (counter % habit.customValue == 0) {
        customAppearance.add(day);
      }
      day = day.add(const Duration(days: 1));
      counter++;
    }
  }

  return customAppearance;
}
