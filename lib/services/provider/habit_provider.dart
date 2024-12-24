import "dart:async";
import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_localization/flutter_localization.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:habitt/data/app_locale.dart";
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
    if (value > allHabitsCompletedStreak) {
      streakBox.put('BestAllHabitsCompletedStreak', value);
    }

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
    List<HabitData> habitsList =
        Provider.of<DataProvider>(context, listen: false).habitsList;
    bool morningCompleted = false;
    bool afternoonCompleted = false;
    bool eveningCompleted = false;
    bool anytimeCompleted = false;
    int morningHabits = 0;
    int morningHabitsCompleted = 0;
    int afternoonHabits = 0;
    int afternoonHabitsCompleted = 0;
    int eveningHabits = 0;
    int eveningHabitsCompleted = 0;
    int anytimeHabits = 0;
    int anytimeHabitsCompleted = 0;
    bool morningHasHabits =
        Provider.of<DataProvider>(context, listen: false).morningHasHabits;
    bool afternoonHasHabits =
        Provider.of<DataProvider>(context, listen: false).afternoonHasHabits;
    bool eveningHasHabits =
        Provider.of<DataProvider>(context, listen: false).eveningHasHabits;
    bool anytimeHasHabits =
        Provider.of<DataProvider>(context, listen: false).anytimeHasHabits;

    for (var habit in habitsList) {
      if (!habit.task) {
        if (habit.category == "Morning") {
          morningHabits++;
          if (habit.completed) {
            morningHabitsCompleted++;
          }
        } else if (habit.category == "Afternoon") {
          afternoonHabits++;
          if (habit.completed) {
            afternoonHabitsCompleted++;
          }
        } else if (habit.category == "Evening") {
          eveningHabits++;
          if (habit.completed) {
            eveningHabitsCompleted++;
          }
        } else {
          anytimeHabits++;
          if (habit.completed) {
            anytimeHabitsCompleted++;
          }
        }
      }
    }

    if (morningHabitsCompleted == morningHabits) {
      morningCompleted = true;
    }
    if (afternoonHabitsCompleted == afternoonHabits) {
      afternoonCompleted = true;
    }
    if (eveningHabitsCompleted == eveningHabits) {
      eveningCompleted = true;
    }
    if (anytimeHabitsCompleted == anytimeHabits) {
      anytimeCompleted = true;
    }

    bool morningReady = false;
    bool afternoonReady = false;
    bool eveningReady = false;
    bool anytimeReady = false;

    if (morningHasHabits) {
      if (!morningCompleted) {
        morningReady = true;
      }
    }

    if (afternoonHasHabits) {
      if (!afternoonCompleted) {
        afternoonReady = true;
      }
    }

    if (eveningHasHabits) {
      if (!eveningCompleted) {
        eveningReady = true;
      }
    }

    if (anytimeHasHabits) {
      if (!anytimeCompleted) {
        anytimeReady = true;
      }
    }

    if (hour >= 4 && hour < 12) {
      if (morningReady) {
        mainCategory = "Morning";
      } else if (anytimeReady) {
        mainCategory = "Any time";
      } else if (afternoonReady) {
        mainCategory = "Afternoon";
      } else if (eveningReady) {
        mainCategory = "Evening";
      } else if (morningHasHabits) {
        mainCategory = "Morning";
      } else {
        mainCategory = "Any time";
      }
    } else if (hour >= 12 && hour < 19) {
      if (afternoonReady) {
        mainCategory = "Afternoon";
      } else if (morningReady) {
        mainCategory = "Morning";
      } else if (anytimeReady) {
        mainCategory = "Any time";
      } else if (eveningReady) {
        mainCategory = "Evening";
      } else if (afternoonHasHabits) {
        mainCategory = "Afternoon";
      } else {
        mainCategory = "Any time";
      }
    } else if (hour >= 19 || hour < 4) {
      if (eveningReady) {
        mainCategory = "Evening";
      } else if (morningReady) {
        mainCategory = "Morning";
      } else if (afternoonReady) {
        mainCategory = "Afternoon";
      } else if (eveningHasHabits) {
        mainCategory = "Evening";
      } else {
        mainCategory = "Any time";
      }
    } else {
      mainCategory = "Any time";
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

    notifyListeners();
  }

  void pauseHabit(HabitData habit, BuildContext context) {
    habit.paused = !habit.paused;
    habit.save();
    if (context.mounted) {
      context.read<DataProvider>().updateHabits(context);
      context.read<DataProvider>().updateAllHabits();
      if (habit.category == mainCategory) {
        chooseMainCategory(context);
        updateMainCategoryHeight(context);
      }

      saveHabitsForToday(context);
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
      customAppearance: existingHabit.customAppearance,
      timesCompletedThisWeek: existingHabit.timesCompletedThisWeek,
      timesCompletedThisMonth: existingHabit.timesCompletedThisMonth,
      paused: existingHabit.paused,
      lastCustomUpdate: existingHabit.lastCustomUpdate,
    );

    await habitBox.putAt(index, updatedHabit);

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
      Fluttertoast.showToast(msg: AppLocale.cantSkipHabit3.getString(context));
      return;
    }

    // Check if the user is skipping two days in a row
    final existingHabit = habitBox.getAt(index)!;

    var historicalList = historicalBox.values.toList();

    historicalList.sort((a, b) {
      DateTime dateA = a.date;
      DateTime dateB = b.date;
      return dateB.compareTo(dateA);
    }); // sorted that 0 is today

    bool shouldBreak = false;

    for (int i = 1; i < historicalList.length; i++) {
      // loop starts from yesterday
      for (int j = 0; j < historicalList[i].data.length; j++) {
        //checks every habit from the day
        if (historicalList[i].data[j].id == existingHabit.id) {
          //if a habit exists in that
          if (historicalList[i].data[j].skipped) {
            // if the habit was skipped
            Fluttertoast.showToast(
                msg: AppLocale.cantSkipHabitRow.getString(context));
            return;
          } else {
            //break the loop;
            shouldBreak = true;
            break;
          }
        }
      }

      if (shouldBreak) {
        break;
      }
    }

    // Skip the habit

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
        customAppearance: existingHabit.customAppearance,
        timesCompletedThisWeek: existingHabit.timesCompletedThisWeek,
        timesCompletedThisMonth: existingHabit.timesCompletedThisMonth,
        paused: existingHabit.paused,
        lastCustomUpdate: existingHabit.lastCustomUpdate);

    await habitBox.putAt(index, updatedHabit);

    if (context.mounted) {
      context.read<DataProvider>().updateHabits(context);
      saveHabitsForToday(context);
    }
    notifyListeners();
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

  Future<void> editHabitProvider(
      int index, context, editcontroller, bool? allHabitsPage) async {
    editHabit(index, context, editcontroller, allHabitsPage);
    Navigator.of(context).pop();

    notifyListeners();
  }

  Future<void> deleteHabitProvider(index, context, editcontroller) async {
    await deleteHabit(index, context, editcontroller);
    notifyListeners();
  }

  applyDurationCompleted(index, BuildContext context) async {
    int theDurationValueHours =
        Provider.of<DataProvider>(context, listen: false).theDurationValueHours;
    int theDurationValueMinutes =
        Provider.of<DataProvider>(context, listen: false)
            .theDurationValueMinutes;

    var habit = habitBox.getAt(index)!;

    await habitBox.putAt(
        index,
        HabitData(
            name: habit.name,
            completed: habit.completed,
            icon: habit.icon,
            category: habit.category,
            streak: habit.streak,
            amount: habit.amount,
            amountName: habit.amountName,
            amountCompleted: habit.amountCompleted,
            duration: habit.duration,
            durationCompleted:
                theDurationValueHours * 60 + theDurationValueMinutes,
            skipped: habit.skipped,
            tag: habit.tag,
            notifications: habit.notifications,
            notes: habit.notes,
            longestStreak: habit.longestStreak,
            id: habit.id,
            task: habit.task,
            type: habit.type,
            weekValue: habit.weekValue,
            monthValue: habit.monthValue,
            customValue: habit.customValue,
            selectedDaysAWeek: habit.selectedDaysAWeek,
            selectedDaysAMonth: habit.selectedDaysAMonth,
            customAppearance: habit.customAppearance,
            timesCompletedThisWeek: habit.timesCompletedThisWeek,
            timesCompletedThisMonth: habit.timesCompletedThisMonth,
            paused: habit.paused,
            lastCustomUpdate: habit.lastCustomUpdate));

    if (context.mounted) {
      context.read<DataProvider>().updateHabits(context);
      saveHabitsForToday(context);
    }
    notifyListeners();
  }

  applyAmountCompleted(index, BuildContext context) async {
    int theAmountValue =
        Provider.of<DataProvider>(context, listen: false).theAmountValue;

    var habit = habitBox.getAt(index)!;

    await habitBox.putAt(
        index,
        HabitData(
            name: habit.name,
            completed: habit.completed,
            icon: habit.icon,
            category: habit.category,
            streak: habit.streak,
            amount: habit.amount,
            amountName: habit.amountName,
            amountCompleted: theAmountValue,
            duration: habit.duration,
            durationCompleted: habit.durationCompleted,
            skipped: habit.skipped,
            tag: habit.tag,
            notifications: habit.notifications,
            notes: habit.notes,
            longestStreak: habit.longestStreak,
            id: habit.id,
            task: habit.task,
            type: habit.type,
            weekValue: habit.weekValue,
            monthValue: habit.monthValue,
            customValue: habit.customValue,
            selectedDaysAWeek: habit.selectedDaysAWeek,
            selectedDaysAMonth: habit.selectedDaysAMonth,
            customAppearance: habit.customAppearance,
            timesCompletedThisWeek: habit.timesCompletedThisWeek,
            timesCompletedThisMonth: habit.timesCompletedThisMonth,
            paused: habit.paused,
            lastCustomUpdate: habit.lastCustomUpdate));
    if (context.mounted) {
      context.read<DataProvider>().updateHabits(context);
      saveHabitsForToday(context);
    }
    notifyListeners();
  }

  Future<void> updateLastOpenedDate(BuildContext context) async {
    DateTime now = DateTime.now();

    DateTime lastOpenedDate = metadataBox.get("lastOpenedDate")!;

    bool isNewMonth =
        now.month != lastOpenedDate.month || now.year != lastOpenedDate.year;
    DateTime normalizedLastOpened =
        DateTime(lastOpenedDate.year, lastOpenedDate.month, lastOpenedDate.day);
    DateTime normalizedNow = DateTime(now.year, now.month, now.day);
    int daysDifference = normalizedNow.difference(normalizedLastOpened).inDays;

    if (daysDifference != 0) {
      resetCompletionStatus(daysDifference,
          isNewMonth); //sets all current habits completed to false
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
    await metadataBox.put("lastOpenedDate", now);
  }

  void resetCompletionStatus(int daysDifference, bool isNewMonth) {
    DateTime today = DateTime.now();

    for (var habit in habitBox.values) {
      if (habit.completed) {
        habit.timesCompletedThisMonth++;
        habit.timesCompletedThisWeek++;
      }

      if (isNewMonth) {
        habit.timesCompletedThisMonth = 0;
      }

      if (daysDifference > 1) {
        if (today.weekday - daysDifference <= 1) {
          habit.timesCompletedThisWeek = 0;
        }
      } else if (today.weekday == 1) {
        habit.timesCompletedThisWeek = 0;
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
