import "dart:async";
import "package:awesome_notifications/awesome_notifications.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:habitt/data/habit_data.dart";
import "package:habitt/pages/home/functions/createNewHabit.dart";
import "package:habitt/pages/home/home_page.dart";
import "package:habitt/services/provider/data_provider.dart";
import "package:habitt/services/provider/historical_habit_provider.dart";
import "package:habitt/services/storage_service.dart";
import "package:habitt/util/functions/habit/deleteHabit.dart";
import "package:habitt/util/functions/habit/editHabit.dart";
import "package:habitt/util/functions/habit/habitsCompleted.dart";
import "package:habitt/util/functions/habit/saveHabitsForToday.dart";
import "package:hive/hive.dart";
import "package:provider/provider.dart";

class HabitProvider extends ChangeNotifier {
  final habitBox = Hive.box<HabitData>('habits');

  String mainCategory = "";
  bool somethingEdited = false;
  bool appearenceEdited = false;
  bool additionalTask = false;

  Icon updatedIcon = startIcon;

  double editHabitPageHeight = 0;

  String timeBasedText = "";

  String dropDownValue = 'Any time';

  int habitGoalValue = 0;
  int duration = 0;
  int durationHours = 0;
  int durationMinutes = 0;
  int amount = 1;
  TextEditingController habitGoalController = TextEditingController();

  TextEditingController notescontroller = TextEditingController();
  bool get displayEmptyCategories =>
      Hive.box<bool>('bool').get('displayEmptyCategories')!;
  double _mainCategoryHeight = 200;
  String? _tagSelected = 'All';
  int allHabitsCompletedStreak = streakBox.get('allHabitsCompletedStreak')!;

  List habitNotifications = [];

  String? get tagSelected => _tagSelected;
  double get mainCategoryHeight => _mainCategoryHeight;
  bool isGestureEnabled = true;
  bool categoriesExpanded = false;
  bool categoryIsVisible = false;

  void updateDropDownValue(String value) {
    dropDownValue = value;
    notifyListeners();
  }

  void updateAppearenceEdited() {
    appearenceEdited = true;
    notifyListeners();
  }

  void resetAppearenceEdited() {
    appearenceEdited = false;
    notifyListeners();
  }

  void updateSomethingEdited() {
    somethingEdited = true;
    getPageHeight(false);
    notifyListeners();
  }

  void resetSomethingEdited() {
    somethingEdited = false;
    notifyListeners();
  }

  setHabitGoalValue(int value) {
    habitGoalValue = value;
    getPageHeight(false);
    notifyListeners();
  }

  updateAllHabitsCompletedStreak(int value) {
    allHabitsCompletedStreak = value;
    streakBox.put('allHabitsCompletedStreak', value);
    notifyListeners();
  }

  getPageHeight(bool firstPage) {
    editHabitPageHeight = 600;
    if (firstPage) {
      editHabitPageHeight += 20;
      if (somethingEdited) {
        editHabitPageHeight += 50;
      }
    } else {
      editHabitPageHeight += 50;
      if (somethingEdited) {
        editHabitPageHeight += 50;
      }
      if (habitGoalValue != 0) {
        editHabitPageHeight += 150;
      }
      if (categoriesExpanded) {
        editHabitPageHeight += 200;
      }
    }
  }

  void toggleExpansion() {
    if (isGestureEnabled) {
      isGestureEnabled = false;

      categoriesExpanded = !categoriesExpanded;
      getPageHeight(false);
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
    habitNotifications = notification;
    notifyListeners();
  }

  void removeNotification(notification) {
    habitNotifications.remove(notification);
    notifyListeners();
  }

  void setTagSelected(String? tag) {
    _tagSelected = tag;
    notifyListeners();
  }

  void chooseMainCategory(BuildContext context) {
    int hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) {
      if (!Provider.of<DataProvider>(context, listen: false).morningHasHabits) {
        mainCategory = "Any time";
      } else {
        mainCategory = "Morning";
      }
    } else if (hour >= 12 && hour < 19) {
      if (!Provider.of<DataProvider>(context, listen: false)
          .afternoonHasHabits) {
        mainCategory = "Any time";
      } else {
        mainCategory = "Afternoon";
      }
    } else if (!Provider.of<DataProvider>(context, listen: false)
        .eveningHasHabits) {
      mainCategory = "Any time";
    } else {
      mainCategory = "Evening";
    }
    notifyListeners();
  }

  void updateMainCategoryHeight(BuildContext context) {
    List<HabitData> habitsList =
        Provider.of<DataProvider>(context, listen: false).habitsList;

    _mainCategoryHeight = 200;
    for (var habit in habitsList) {
      if (!habit.task) {
        if (habit.category == 'Morning') {
          if (mainCategory == 'Morning') {
            _mainCategoryHeight += 70;
          }
        } else if (habit.category == 'Afternoon') {
          if (mainCategory == 'Afternoon') {
            _mainCategoryHeight += 70;
          }
        } else if (habit.category == 'Evening') {
          if (mainCategory == 'Evening') {
            _mainCategoryHeight += 70;
          }
        } else if (mainCategory == 'Any time') {
          _mainCategoryHeight += 70;
        }
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

  void updateEditHistoricalHabits(bool value) {
    boolBox.put("editHistoricalHabits", value);
    notifyListeners();
  }

  void updateAdditionalTasks(bool value) {
    additionalTask = value;
    notifyListeners();
  }

  Future<void> createNewHabitProvider(
      createcontroller, BuildContext context) async {
    await createNewHabit(createcontroller, context);
    if (context.mounted) {
      saveHabitsForToday(context);
      updateMainCategoryHeight(context);
      chooseMainCategory(context);
    }

    notifyListeners();
  }

  Future<void> completeHabitProvider(
      int index, bool isAdLoaded, interstitialAd, BuildContext context) async {
    final existingHabit = habitBox.getAt(index);

    bool isTask = habitBox.getAt(index)!.task;

    if (existingHabit == null) {
      return;
    }
    final updatedHabit = HabitData(
      name: existingHabit.name,
      completed: !existingHabit.completed,
      icon: existingHabit.icon,
      category: existingHabit.category,
      streak: existingHabit.streak,
      amount: existingHabit.amount,
      amountName: existingHabit.amountName,
      amountCompleted: !existingHabit.completed
          ? existingHabit.amount
          : !existingHabit.skipped
              ? 0
              : existingHabit.amountCompleted,
      duration: existingHabit.duration,
      durationCompleted: !existingHabit.completed
          ? existingHabit.duration
          : !existingHabit.skipped
              ? 0
              : existingHabit.durationCompleted,
      skipped: false,
      tag: existingHabit.tag,
      notifications: existingHabit.notifications,
      notes: existingHabit.notes,
      longestStreak: existingHabit.longestStreak,
      id: existingHabit.id,
      task: existingHabit.task,
      type: existingHabit.type,
      weekValue: existingHabit.weekValue,
      monthValue: existingHabit.monthValue,
      customValue: existingHabit.customValue,
      selectedDaysAWeek: existingHabit.selectedDaysAWeek,
      selectedDaysAMonth: existingHabit.selectedDaysAMonth,
      daysUntilAppearance: existingHabit.daysUntilAppearance,
      timesCompletedThisWeek: existingHabit.timesCompletedThisWeek,
      timesCompletedThisMonth: existingHabit.timesCompletedThisMonth,
    );

    await habitBox.putAt(index, updatedHabit);

    if (context.mounted) {
      context.read<DataProvider>().updateHabits(context);
    }

    // apply haptic feedback or sound
    bool hapticFeedback = boolBox.get('hapticFeedback')!;
    if (context.mounted) {
      if (allHabitsCompleted(context)) {
        if (isAdLoaded) {
          interstitialAd.show();
        }
        playSound();
        if (hapticFeedback) {
          HapticFeedback.heavyImpact();
        }
      } else if (!existingHabit.completed) {
        if (hapticFeedback) {
          HapticFeedback.mediumImpact();
        }
      }
    }

    if (!existingHabit.completed) {
      for (int j = 0; j < habitBox.getAt(index)!.notifications.length; j++) {
        await AwesomeNotifications().cancel(index * 100 + j);
      }

      String habitCategory = habitBox.getAt(index)!.category;
      int totalHabitsInCategory = 0;
      int completedHabitsInCategory = 0;

      int totalTasksInCategory = 0;
      int completedTasksInCategory = 0;

      for (var habit in habitBox.values) {
        // used to check if the category is completed so ad is only shown if so
        if (habit.category == habitCategory) {
          totalHabitsInCategory++;
          if (habit.completed && !habit.task) {
            completedHabitsInCategory++;
          }
        }

        if (isTask) {
          if (habit.task) {
            totalTasksInCategory++;
            if (habit.completed) {
              completedTasksInCategory++;
            }
          }
        }
      }

      if (isTask) {
        if (totalTasksInCategory == completedTasksInCategory) {
          if (isAdLoaded) {
            interstitialAd.show();
          }
        }
      } else if (totalHabitsInCategory == completedHabitsInCategory) {
        if (isAdLoaded) {
          interstitialAd.show();
        }
      }
    }

    if (context.mounted) {
      context.read<DataProvider>().updateHabits(context);
      saveHabitsForToday(context);
    }
    notifyListeners();
  }

  void skipHabitProvider(int index, BuildContext context) async {
    // Check if the user is skipping more than 3 habits a day

    int habitsSkipped = 0;

    for (var habit in habitBox.values) {
      if (habit.skipped) {
        habitsSkipped++;
      }
    }

    if (habitsSkipped >= 3) {
      Fluttertoast.showToast(msg: "You can't skip more than 3 habits a day.");
      return;
    }

    // Check if the user is skipping two days in a row
    DateTime now = DateTime.now();
    List currentDate = [now.year, now.month, now.day];
    final existingHabit = habitBox.getAt(index);

    var historicalList = historicalBox.values.toList();

    historicalList.sort((a, b) {
      DateTime dateA = a.date;
      DateTime dateB = b.date;
      return dateA.compareTo(dateB);
    });

    for (int i = 0; i < historicalList.length; i++) {
      List habitDate = [
        historicalList[i].date.year,
        historicalList[i].date.month,
        historicalList[i].date.day
      ];

      if (const ListEquality().equals(habitDate, currentDate)) {
        if (historicalList[i - 1].data[index].skipped) {
          Fluttertoast.showToast(
              msg: "You can't skip a habit two days in a row.");
          return;
        }
      }
    }

    // Skip the habit

    if (existingHabit != null) {
      final updatedHabit = HabitData(
          name: existingHabit.name,
          completed: !existingHabit.completed,
          icon: existingHabit.icon,
          category: existingHabit.category,
          streak: existingHabit.streak,
          amount: existingHabit.amount,
          amountName: existingHabit.amountName,
          amountCompleted: existingHabit.amountCompleted,
          duration: existingHabit.duration,
          durationCompleted: existingHabit.durationCompleted,
          skipped: !existingHabit.skipped,
          tag: existingHabit.tag,
          notifications: existingHabit.notifications,
          notes: existingHabit.notes,
          longestStreak: existingHabit.longestStreak,
          id: existingHabit.id,
          task: existingHabit.task,
          type: existingHabit.type,
          weekValue: existingHabit.weekValue,
          monthValue: existingHabit.monthValue,
          customValue: existingHabit.customValue,
          selectedDaysAWeek: existingHabit.selectedDaysAWeek,
          selectedDaysAMonth: existingHabit.selectedDaysAMonth,
          daysUntilAppearance: existingHabit.daysUntilAppearance,
          timesCompletedThisWeek: existingHabit.timesCompletedThisWeek,
          timesCompletedThisMonth: existingHabit.timesCompletedThisMonth);

      await habitBox.putAt(index, updatedHabit);

      if (context.mounted) {
        context.read<DataProvider>().updateHabits(context);
        saveHabitsForToday(context);
      }
      notifyListeners();
    }
  }

  HabitData getHabitAt(int id) {
    for (var habit in habitBox.values) {
      if (habit.id == id) {
        return habit;
      }
    }

    return habitBox.getAt(0)!;
  }

  int getIndexFromId(int id) {
    for (int i = 0; i < habitBox.length; i++) {
      if (habitBox.getAt(i)!.id == id) {
        return i;
      }
    }
    return 0;
  }

  Future<void> editHabitProvider(int index, context, editcontroller) async {
    editHabit(index, context, editcontroller);
    if (context.mounted) {
      saveHabitsForToday(context);
    }
    chooseMainCategory(context);
    updateMainCategoryHeight(context);
    Navigator.of(context).pop();

    notifyListeners();
  }

  Future<void> deleteHabitProvider(index, context, editcontroller) async {
    await deleteHabit(index, context, editcontroller);
    if (context.mounted) {
      saveHabitsForToday(context);
    }
    //if (checkIfAllEmpty(context)) {
    // Restart.restartApp();
    //}

    chooseMainCategory(context);
    updateMainCategoryHeight(context);
    notifyListeners();
  }

  applyDurationCompleted(index, BuildContext context) {
    int theDurationValueHours =
        Provider.of<DataProvider>(context, listen: false).theDurationValueHours;
    int theDurationValueMinutes =
        Provider.of<DataProvider>(context, listen: false)
            .theDurationValueMinutes;

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
            id: habitBox.getAt(index)!.id,
            task: habitBox.getAt(index)!.task,
            type: habitBox.getAt(index)!.type,
            weekValue: habitBox.getAt(index)!.weekValue,
            monthValue: habitBox.getAt(index)!.monthValue,
            customValue: habitBox.getAt(index)!.customValue,
            selectedDaysAWeek: habitBox.getAt(index)!.selectedDaysAWeek,
            selectedDaysAMonth: habitBox.getAt(index)!.selectedDaysAMonth,
            daysUntilAppearance: habitBox.getAt(index)!.daysUntilAppearance,
            timesCompletedThisWeek:
                habitBox.getAt(index)!.timesCompletedThisWeek,
            timesCompletedThisMonth:
                habitBox.getAt(index)!.timesCompletedThisMonth));
    if (context.mounted) {
      saveHabitsForToday(context);
    }
    notifyListeners();
  }

  applyAmountCompleted(index, BuildContext context) {
    int theAmountValue =
        Provider.of<DataProvider>(context, listen: false).theAmountValue;

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
            id: habitBox.getAt(index)!.id,
            task: habitBox.getAt(index)!.task,
            type: habitBox.getAt(index)!.type,
            weekValue: habitBox.getAt(index)!.weekValue,
            monthValue: habitBox.getAt(index)!.monthValue,
            customValue: habitBox.getAt(index)!.customValue,
            selectedDaysAWeek: habitBox.getAt(index)!.selectedDaysAWeek,
            selectedDaysAMonth: habitBox.getAt(index)!.selectedDaysAMonth,
            daysUntilAppearance: habitBox.getAt(index)!.daysUntilAppearance,
            timesCompletedThisWeek:
                habitBox.getAt(index)!.timesCompletedThisWeek,
            timesCompletedThisMonth:
                habitBox.getAt(index)!.timesCompletedThisMonth));
    if (context.mounted) {
      saveHabitsForToday(context);
    }
    notifyListeners();
  }

  void updateLastOpenedDate(BuildContext context) async {
    DateTime now = DateTime.now();
    int day = now.day;
    int lastOpenedDate = streakBox.get('lastOpenedDay') ?? 0;
    int daysDifference = day - lastOpenedDate;

    await streakBox.put('lastOpenedDay', day);

    if (daysDifference > 0 || daysDifference < 0) {
      resetCompletionStatus(); //sets all current habits completed to false
      if (context.mounted) {
        saveHabitsForToday(
            context); //puts all current habits to historical habits
      }
      if (context.mounted) {
        context.read<HistoricalHabitProvider>().calculateStreak(context);
        if (userId != null) {
          await backupHiveBoxesToFirebase(userId, true, context);
        }
      }
    }
  }

  void resetCompletionStatus() {
    DateTime today = DateTime.now();

    for (var habit in habitBox.values) {
      if (habit.completed) {
        habit.timesCompletedThisMonth++;
        habit.timesCompletedThisWeek++;
      }

      if (today.day == 1) {
        habit.timesCompletedThisMonth = 0;
      }
      if (today.weekday == 1) {
        habit.timesCompletedThisWeek = 0;
      }

      if (habit.daysUntilAppearance == 0) {
        habit.daysUntilAppearance = habit.customValue - 1;
      } else {
        habit.daysUntilAppearance--;
      }

      habit.amountCompleted = 0;
      habit.durationCompleted = 0;
      habit.completed = false;
      habit.skipped = false;
      habit.save();
    }
    notifyListeners();
  }
}
