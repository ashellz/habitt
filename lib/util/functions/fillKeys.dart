import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/storage_service.dart';

fillKeys() {
  if (habitBox.isEmpty) {
    addInitialData();
  }

  if (!boolBox.containsKey("12hourFormat")) {
    boolBox.put("12hourFormat", false);
  }

  if (!listBox.containsKey("morningNotificationTime")) {
    listBox.put("morningNotificationTime", [9, 0]);
  }

  if (!listBox.containsKey("afternoonNotificationTime")) {
    listBox.put("afternoonNotificationTime", [14, 0]);
  }

  if (!listBox.containsKey("eveningNotificationTime")) {
    listBox.put("eveningNotificationTime", [21, 0]);
  }

  if (!listBox.containsKey("dailyNotificationTime")) {
    listBox.put("dailyNotificationTime", [19, 0]);
  }

  if (!boolBox.containsKey("hapticFeedback")) {
    boolBox.put("hapticFeedback", true);
  }

  if (!boolBox.containsKey("sound")) {
    boolBox.put("sound", true);
  }

  if (!boolBox.containsKey("displayEmptyCategories")) {
    boolBox.put("displayEmptyCategories", false);
  }

  if (!streakBox.containsKey('lastOpenedDay')) {
    streakBox.put(
      'lastOpenedDay',
      DateTime.now().day,
    );
  }
  if (!streakBox.containsKey('lastOpenedMonth')) {
    streakBox.put(
      'lastOpenedMonth',
      DateTime.now().month,
    );
  }
  if (!streakBox.containsKey('allHabitsCompletedStreak')) {
    streakBox.put('allHabitsCompletedStreak', 0);
  }
  if (!boolBox.containsKey('morningNotification')) {
    boolBox.put('morningNotification', false);
  }
  if (!boolBox.containsKey('afternoonNotification')) {
    boolBox.put('afternoonNotification', false);
  }
  if (!boolBox.containsKey('eveningNotification')) {
    boolBox.put('eveningNotification', false);
  }
  if (!boolBox.containsKey('dailyNotification')) {
    boolBox.put('dailyNotification', true);
  }
  if (!boolBox.containsKey('hasNotificationAccess')) {
    boolBox.put('hasNotificationAccess', false);
  }
  if (!boolBox.containsKey('disabledBatteryOptimization')) {
    boolBox.put('disabledBatteryOptimization', false);
  }

  if (boolBox.get("isGuest") == null) {
    boolBox.put("isGuest", false);
  }

  if (boolBox.get("isLoggenIn") == null) {
    boolBox.put("isLoggenIn", false);
  }
}

checkForDayJoined() {
  if (!metadataBox.containsKey("dayJoined")) {
    var historicalList = historicalBox.values.toList();

    historicalList.sort((a, b) {
      DateTime dateA = a.date;
      DateTime dateB = b.date;
      return dateA
          .compareTo(dateB); // This will sort from oldest to most recent
    });

    metadataBox.put("dayJoined", historicalList[0].date);
  }
}
