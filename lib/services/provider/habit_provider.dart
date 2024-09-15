import "dart:async";
import "package:flutter/material.dart";
import "package:habit_tracker/data/habit_tile.dart";
import "package:habit_tracker/main.dart";
import "package:habit_tracker/pages/new_home_page.dart";
import "package:habit_tracker/services/storage_service.dart";
import "package:habit_tracker/util/functions/habit/checkIfEmpty.dart";
import "package:habit_tracker/util/functions/habit/createNewHabit.dart";
import "package:habit_tracker/util/functions/habit/deleteHabit.dart";
import "package:habit_tracker/util/functions/habit/editHabit.dart";
import "package:habit_tracker/util/functions/habit/habitsCompleted.dart";
import "package:habit_tracker/util/functions/habit/saveHabits.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:restart_app/restart_app.dart";
import 'package:vibration/vibration.dart';

class HabitProvider extends ChangeNotifier {
  final habitBox = Hive.box<HabitData>('habits');
  String mainCategory = "";
  bool somethingEdited = false;
  Icon updatedIcon = startIcon;

  String dropDownValue = 'Any time';

  int habitGoalValue = 0;
  int duration = 0;
  int durationHours = 0;
  int durationMinutes = 0;
  int amount = 1;
  TextEditingController habitGoalController = TextEditingController();

  TextEditingController notescontroller = TextEditingController();

  int get habitListLength => Hive.box<HabitData>('habits').length;
  bool get displayEmptyCategories =>
      Hive.box<bool>('bool').get('displayEmptyCategories')!;
  double _mainCategoryHeight = 200;
  String? _tagSelected = 'All';

  List _habitNotifications = [];

  List get habitNotifications => _habitNotifications;
  String? get tagSelected => _tagSelected;
  double get mainCategoryHeight => _mainCategoryHeight;
  int get allHabitsCompletedStreak =>
      streakBox.get('allHabitsCompletedStreak')!;
  bool isGestureEnabled = true;
  bool categoriesExpanded = false;
  bool categoryIsVisible = false;

  void updateDropDownValue(String value) {
    dropDownValue = value;
    notifyListeners();
  }

  void updateSomethingEdited() {
    somethingEdited = true;
    notifyListeners();
  }

  void resetSomethingEdited() {
    somethingEdited = false;
    notifyListeners();
  }

  void toggleExpansion() {
    if (isGestureEnabled) {
      isGestureEnabled = false;

      categoriesExpanded = !categoriesExpanded;
      if (categoriesExpanded) {
        Timer(const Duration(milliseconds: 500), () {
          categoryIsVisible = true;
          notifyListeners();
        });
      } else {
        categoryIsVisible = false;
      }

      Timer(const Duration(milliseconds: 500), () {
        isGestureEnabled = true;
      });
    }
    notifyListeners();
  }

  void changeNotification(List notification) {
    _habitNotifications = notification;
    notifyListeners();
  }

  void removeNotification(notification) {
    _habitNotifications.remove(notification);
    notifyListeners();
  }

  void setTagSelected(String? tag) {
    _tagSelected = tag;
    notifyListeners();
  }

  void chooseMainCategory() {
    int hour = DateTime.now().hour;
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

  void updateHourFormat(bool value) {
    boolBox.put('12hourFormat', value);
    notifyListeners();
  }

  Future<void> createNewHabitProvider(
      createcontroller, BuildContext context) async {
    await createNewHabit(createcontroller, context);
    saveHabitsForToday();
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
        notes: existingHabit.notes,
        longestStreak: existingHabit.longestStreak,
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

      saveHabitsForToday();
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
        notes: existingHabit.notes,
        longestStreak: existingHabit.longestStreak,
      );

      await habitBox.putAt(index, updatedHabit);
      saveHabitsForToday();
      notifyListeners();
    }
  }

  HabitData getHabitAt(int index) {
    return habitBox.getAt(index)!;
  }

  Future<void> editHabitProvider(int index, context, editcontroller) async {
    editHabit(index, context, editcontroller);
    saveHabitsForToday();
    chooseMainCategory();
    updateMainCategoryHeight();
    Navigator.of(context).pop();

    notifyListeners();
  }

  Future<void> deleteHabitProvider(index, context, editcontroller) async {
    await deleteHabit(index, context, editcontroller);
    saveHabitsForToday();
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
          notes: habitBox.getAt(index)!.notes,
          longestStreak: habitBox.getAt(index)!.longestStreak,
        ));
    saveHabitsForToday();
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
          notes: habitBox.getAt(index)!.notes,
          longestStreak: habitBox.getAt(index)!.longestStreak,
        ));
    saveHabitsForToday();
    notifyListeners();
  }

  void updateLastOpenedDate() async {
    DateTime now = DateTime.now();
    int day = now.day;
    int lastOpenedDate = streakBox.get('lastOpenedDay') ?? 0;
    int daysDifference = day - lastOpenedDate;

    await streakBox.put('lastOpenedDay', day);

    if (daysDifference > 0 || daysDifference < 0) {
      resetCompletionStatus();
      saveHabitsForToday();

      if (userId != null) {
        await backupHiveBoxesToFirebase(userId);
      }
    }
  }

  void resetCompletionStatus() {
    for (int i = 0; i < habitBox.length; i++) {
      var habit = habitBox.getAt(i)!;
      habit.amountCompleted = 0;
      habit.durationCompleted = 0;
      habit.completed = false;
      habit.skipped = false;
      habit.save();
    }
    notifyListeners();
  }
}
