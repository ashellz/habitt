import "package:flutter/material.dart";
import "package:habit_tracker/data/habit_tile.dart";
import "package:habit_tracker/main.dart";
import "package:habit_tracker/util/functions/habit/createNewHabit.dart";
import "package:habit_tracker/util/functions/habit/deleteHabit.dart";
import "package:habit_tracker/util/functions/habit/editHabit.dart";
import "package:hive_flutter/hive_flutter.dart";

class HabitProvider extends ChangeNotifier {
  final habitBox = Hive.box<HabitData>('habits');
  String mainCategory = "Morning";

  int get habitListLength => Hive.box<HabitData>('habits').length;
  bool get displayEmptyCategories =>
      Hive.box<bool>('bool').get('displayEmptyCategories')!;
  double _mainCategoryHeight = 200;

  double get mainCategoryHeight => _mainCategoryHeight;
  String get _mainCategory => mainCategory;

  void chooseMainCategory() {
    int hour = DateTime.now().hour;
    print("Hour $hour");
    if (hour >= 4 && hour < 12) {
      if (!morningHasHabits) {
        mainCategory = "Any time";
      } else {
        mainCategory = "Morning";
      }
    } else if (hour >= 12 && hour < 19) {
      if (!afternoonHasHabits) {
        mainCategory = "Any time";
      } else {
        mainCategory = "Afternoon";
      }
    } else if (!eveningHasHabits) {
      mainCategory = "Any time";
    } else {
      mainCategory = "Evening";
    }
    notifyListeners();
  }

  void updateMainCategoryHeight() {
    _mainCategoryHeight = 200;
    for (int i = 0; i < habitListLength; i++) {
      if (habitBox.getAt(i)?.category == 'Morning') {
        if (mainCategory == 'Morning') {
          _mainCategoryHeight += 70;
        }
      } else if (habitBox.getAt(i)?.category == 'Afternoon') {
        if (mainCategory == 'Afternoon') {
          _mainCategoryHeight += 70;
        }
      } else if (habitBox.getAt(i)?.category == 'Evening') {
        if (mainCategory == 'Evening') {
          _mainCategoryHeight += 70;
        }
      } else if (mainCategory == 'Any time') {
        _mainCategoryHeight += 70;
      }
    }
    _mainCategoryHeight -= 70;

    if (_mainCategoryHeight == 130) {
      _mainCategoryHeight = 200;
    }
    notifyListeners();
  }

  void updateDisplayEmptyCategories(bool value) {
    Hive.box<bool>('bool').put('displayEmptyCategories', !value);
    notifyListeners();
  }

  Future<void> createNewHabitProvider(createcontroller) async {
    await createNewHabit(createcontroller);
    chooseMainCategory();
    updateMainCategoryHeight();
    notifyListeners();
  }

  void completeHabitProvider(int index) async {
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
        durationCompleted:
            !existingHabit.completed ? existingHabit.duration : 0,
      );

      await habitBox.putAt(index, updatedHabit);
      notifyListeners();
    }
  }

  HabitData getHabitAt(int index) {
    return habitBox.getAt(index)!;
  }

  Future<void> editHabitProvider(int index, context, editcontroller) async {
    editHabit(index, context, editcontroller);
    chooseMainCategory();

    updateMainCategoryHeight();
    notifyListeners();
  }

  Future<void> deleteHabitProvider(index, context, editcontroller) async {
    await deleteHabit(index, context, editcontroller);
    chooseMainCategory();
    updateMainCategoryHeight();
    notifyListeners();
  }
}
