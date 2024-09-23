import 'package:habit_tracker/pages/home_page.dart';

bool categoryCompleted(String category) {
  int habits = 0;
  int completedHabits = 0;

  List<String> realCategories = ["Any time", "Morning", "Afternoon", "Evening"];

  if (category == "All") {
    return allHabitsCompleted();
  }

  if (!realCategories.contains(category)) {
    return tagCompleted(category);
  }

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)?.category == category) {
      habits++;

      if (habitBox.getAt(i)?.completed == true) {
        completedHabits++;
      }
    }
  }

  if (completedHabits == habits) {
    return true;
  } else {
    return false;
  }
}

bool tagCompleted(String tag) {
  int habits = 0;
  int completedHabits = 0;

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)?.tag == tag) {
      habits++;

      if (habitBox.getAt(i)?.completed == true) {
        completedHabits++;
      }
    }
  }

  if (completedHabits == habits) {
    return true;
  } else {
    return false;
  }
}

bool allHabitsCompleted() {
  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)?.completed == false) {
      return false;
    }
  }
  return true;
}
