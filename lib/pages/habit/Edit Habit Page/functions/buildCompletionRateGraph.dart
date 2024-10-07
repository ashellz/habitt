import 'package:habitt/pages/home/home_page.dart';

void buildCompletionRateGraph(
    int index,
    List completionRates,
    double? highestCompletionRate,
    double? lowestCompletionRate,
    List<int> everyFifthDay,
    List<int> everyFifthMonth) {
  var historicalList = historicalBox.values.toList();

  historicalList.sort((b, a) {
    DateTime dateA = a.date;
    DateTime dateB = b.date;
    return dateA.compareTo(dateB);
  });

  everyFifthDay.clear();
  everyFifthMonth.clear();
  completionRates.clear();
  highestCompletionRate = 0;
  lowestCompletionRate = 100;

  int habitId = habitBox.getAt(index)!.id;
  int day = 30;

  for (int i = 0; i < historicalList.length; i++) {
    if (i == 30) {
      break;
    }

    print("number i: $i");

    int habitsCompleted = 0;
    int totalHabits = 0;
    if (day % 5 == 0) {
      print("every fifth day: true");
      everyFifthDay.add(historicalList[i].date.day);
      everyFifthMonth.add(historicalList[i].date.month);
    }

    for (int j = 0; j < historicalList.length; j++) {
      if (j == 30) {
        break;
      }

      print("number j: $j");

      if (j + i < historicalList.length) {
        print(
            "number j + i: ${j + i} and histoprical length:  ${historicalList.length}");
        for (var historicalHabit in historicalList[j + i].data) {
          if (historicalHabit.id == habitId) {
            if (historicalHabit.completed && !historicalHabit.skipped) {
              habitsCompleted++;
            }
            totalHabits++;
          }
        }
      }
    }

    double completionRate = (habitsCompleted / totalHabits) * 100;
    if (totalHabits == 0) {
      completionRate = 0;
    }

    if (completionRate > highestCompletionRate!) {
      highestCompletionRate = completionRate;
    }
    if (completionRate < lowestCompletionRate!) {
      lowestCompletionRate = completionRate;
    }

    completionRates.add(completionRate);

    print(completionRates);
    day--;
  }

  while (completionRates.length < 30) {
    completionRates.add(0.toDouble());
  }

  while (everyFifthDay.length < 6 || everyFifthMonth.length < 6) {
    everyFifthDay.add(0);
    everyFifthMonth.add(13);
  }
}
