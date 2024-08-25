import "dart:async";
import "package:flutter/material.dart";
import "package:habit_tracker/data/habit_tile.dart";
import "package:habit_tracker/data/historical_habit.dart";
import "package:habit_tracker/main.dart";
import "package:habit_tracker/pages/new_home_page.dart";
import "package:habit_tracker/util/functions/habit/checkIfEmpty.dart";
import "package:habit_tracker/util/functions/habit/createNewHabit.dart";
import "package:habit_tracker/util/functions/habit/deleteHabit.dart";
import "package:habit_tracker/util/functions/habit/editHabit.dart";
import "package:habit_tracker/util/functions/habit/habitsCompleted.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:restart_app/restart_app.dart";
import 'package:vibration/vibration.dart';
import 'package:collection/collection.dart';

class HabitProvider extends ChangeNotifier {
  final habitBox = Hive.box<HabitData>('habits');
  String mainCategory = "";

  int get habitListLength => Hive.box<HabitData>('habits').length;
  bool get displayEmptyCategories =>
      Hive.box<bool>('bool').get('displayEmptyCategories')!;
  double _mainCategoryHeight = 200;
  String? _tagSelected = 'All';

  List get allHistoricalHabits => historicalBox.values.toList();
  List _habitNotifications = [];

  List get habitNotifications => _habitNotifications;
  String? get tagSelected => _tagSelected;
  double get mainCategoryHeight => _mainCategoryHeight;
  String get _mainCategory => mainCategory;

  void changeNotification(List notification) {
    print("notification has be changed to $notification");
    _habitNotifications = notification;
    notifyListeners();
  }

  void removeNotification(notification) {
    _habitNotifications.remove(notification);
    notifyListeners();
  }

  void setTagSelected(String? tag) {
    print("Tag selected: $tag");
    _tagSelected = tag;
    notifyListeners();
  }

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
    boolBox.put('displayEmptyCategories', value);
    notifyListeners();
  }

  void updateHapticFeedback(bool value) {
    boolBox.put('hapticFeedback', value);
    notifyListeners();
  }

  void updateSound(bool value) {
    boolBox.put('sound', value);
    notifyListeners();
  }

  Future<void> createNewHabitProvider(
      createcontroller, BuildContext context) async {
    await createNewHabit(createcontroller, context);
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
        skipped: false,
        tag: existingHabit.tag,
        notifications: existingHabit.notifications,
      );

      await habitBox.putAt(index, updatedHabit);

      bool hapticFeedback = boolBox.get('hapticFeedback')!;
      if (allHabitsCompleted()) {
        playSound();
        if (hapticFeedback) {
          Vibration.vibrate(duration: 500);
        }
      } else if (!existingHabit.completed) {
        if (hapticFeedback) {
          Vibration.vibrate(duration: 100);
        }
      }

      notifyListeners();
    }
  }

  void skipHabitProvider(int index) async {
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
        skipped: !existingHabit.skipped,
        tag: existingHabit.tag,
        notifications: existingHabit.notifications,
      );

      await habitBox.putAt(index, updatedHabit);
      notifyListeners();
    }
  }

  void skipHistoricalHabit(int index, habit) async {
    print("function skip historical habit");
    print("habit before: ${habit.skipped}");

    habit.completed = !habit.completed;
    habit.amountCompleted = !habit.completed ? habit.amount : 0;
    habit.durationCompleted = !habit.completed ? habit.duration : 0;
    habit.skipped = !habit.skipped;

    print("habit after: ${habit.skipped}");
    notifyListeners();
  }

  void completeHistoricalHabit(int index, habit) async {
    habit.completed = !habit.completed;
    habit.amountCompleted = habit.completed ? habit.amount : 0;
    habit.durationCompleted = habit.completed ? habit.duration : 0;
    habit.skipped = false;

    bool hapticFeedback = boolBox.get('hapticFeedback')!;
    /*if (allHabitsCompleted()) {
      playSound();
      if (hapticFeedback) {
        Vibration.vibrate(duration: 500);
      }
    } else*/
    if (!habit.completed) {
      if (hapticFeedback) {
        Vibration.vibrate(duration: 100);
      }
    }

    notifyListeners();
  }

  HabitData getHabitAt(int index) {
    return habitBox.getAt(index)!;
  }

  HistoricalHabitData getHistoricalHabitAt(int index, DateTime today) {
    List<int> date = [today.year, today.month, today.day];

    for (int i = 0; i < historicalBox.length; i++) {
      List<int> habitDate = [
        historicalBox.getAt(i)!.date.year,
        historicalBox.getAt(i)!.date.month,
        historicalBox.getAt(i)!.date.day
      ];

      if (const ListEquality().equals(habitDate, date)) {
        return historicalBox.getAt(i)!.data[index];
      }
    }

    return historicalBox.getAt(0)!.data[index]; // default
  }

  Future<void> editHabitProvider(int index, context, editcontroller) async {
    editHabit(index, context, editcontroller);
    chooseMainCategory();
    updateMainCategoryHeight();
    Navigator.of(context).pop();

    notifyListeners();
  }

  Future<void> deleteHabitProvider(index, context, editcontroller) async {
    await deleteHabit(index, context, editcontroller);
    if (checkIfAllEmpty()) {
      Restart.restartApp();
    }

    chooseMainCategory();
    updateMainCategoryHeight();
    notifyListeners();
  }

  applyDurationCompleted(
      index, int theDurationValueHours, int theDurationValueMinutes) {
    habitBox.putAt(
        index,
        HabitData(
          name: habitBox.getAt(index)!.name,
          completed: habitBox.getAt(index)!.completed,
          icon: habitBox.getAt(index)!.icon,
          category: habitBox.getAt(index)!.category,
          streak: habitBox.getAt(index)!.streak,
          amount: habitBox.getAt(index)!.amount,
          amountName: habitBox.getAt(index)!.amountName,
          amountCompleted: habitBox.getAt(index)!.amountCompleted,
          duration: habitBox.getAt(index)!.duration,
          durationCompleted:
              theDurationValueHours * 60 + theDurationValueMinutes,
          skipped: habitBox.getAt(index)!.skipped,
          tag: habitBox.getAt(index)!.tag,
          notifications: habitBox.getAt(index)!.notifications,
        ));
    notifyListeners();
  }

  applyAmountCompleted(index, theAmountValue) {
    habitBox.putAt(
        index,
        HabitData(
          name: habitBox.getAt(index)!.name,
          completed: habitBox.getAt(index)!.completed,
          icon: habitBox.getAt(index)!.icon,
          category: habitBox.getAt(index)!.category,
          streak: habitBox.getAt(index)!.streak,
          amount: habitBox.getAt(index)!.amount,
          amountName: habitBox.getAt(index)!.amountName,
          amountCompleted: theAmountValue,
          duration: habitBox.getAt(index)!.duration,
          durationCompleted: habitBox.getAt(index)!.durationCompleted,
          skipped: habitBox.getAt(index)!.skipped,
          tag: habitBox.getAt(index)!.tag,
          notifications: habitBox.getAt(index)!.notifications,
        ));
    notifyListeners();
  }

  applyHistoricalAmountCompleted(habit, theAmountValue) {
    habit.amountCompleted = theAmountValue;

    notifyListeners();
  }

  applyHistoricalDurationCompleted(
      habit, int theDurationValueHours, int theDurationValueMinutes) {
    habit.durationCompleted =
        theDurationValueHours * 60 + theDurationValueMinutes;

    notifyListeners();
  }
}
