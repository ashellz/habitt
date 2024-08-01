import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/add_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';

late HabitData myHabit;

Future<void> createNewHabit(createcontroller) async {
  currentDurationValue =
      currentDurationValueMinutes + (currentDurationValueHours * 60);

  myHabit = HabitData(
      name: createcontroller.text,
      completed: false,
      icon: getIconString(updatedIcon.icon),
      category: dropDownValue,
      streak: 0,
      amount: habitGoal == 1 ? currentAmountValue : 1,
      amountName: amountNameController.text,
      amountCompleted: 0,
      duration: habitGoal == 2 ? currentDurationValue : 0,
      durationCompleted: 0,
      skipped: false,
      tag: habitTag);
  await habitBox.add(myHabit);
  hasHabits();

  createcontroller.clear();
  updatedIcon = startIcon;
  dropDownValue = 'Any time';
  amountNameController.text = "times";
  currentAmountValue = 2;
  currentDurationValueMinutes = 0;
  currentDurationValueHours = 0;
  currentDurationValue = 0;
  habitGoal = 0;
  habitTag = "No tag";
  //showPopup(context, "Habit added!");
}
