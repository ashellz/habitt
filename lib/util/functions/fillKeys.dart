import 'package:flutter/foundation.dart';
// import 'package:habit_tracker/services/storage_service.dart';
import 'package:habitt/pages/home/home_page.dart';

fillKeys() {
  for (int i = 0; i < historicalBox.length; i++) {
    for (int j = 0; j < historicalBox.getAt(i)!.data.length; j++) {
      if (historicalBox.getAt(i)!.data[j].id == 12345) {
        historicalBox.getAt(i)!.data[j].id = j;
      }
    }
  }

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)!.id == 12345) {
      habitBox.getAt(i)!.id = i;
    }

    int id = habitBox.getAt(i)!.id;

    if (kDebugMode) {
      print("id at index $i is $id");
    }
  }

  if (!streakBox.containsKey('highestId')) {
    streakBox.put('highestId', habitBox.length - 1);
  }

  if (!boolBox.containsKey("blackColor")) {
    boolBox.put("blackColor", false);
  }
  if (!boolBox.containsKey("editHistoricalHabits")) {
    boolBox.put("editHistoricalHabits", true);
  }
  if (!boolBox.containsKey("realBlack")) {
    boolBox.put("realBlack", false);
  }

  if (!boolBox.containsKey("firstTimeEditAppearence")) {
    boolBox.put("firstTimeEditAppearence", true);
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
  if (!boolBox.containsKey('accountDeletionPending')) {
    boolBox.put('accountDeletionPending', false);
  }

  if (boolBox.get("isGuest") == null) {
    boolBox.put("isGuest", false);
  }

  if (boolBox.get("isLoggenIn") == null) {
    boolBox.put("isLoggenIn", false);
  }

  if (stringBox.get("language") == null) {
    stringBox.put("language", "en");
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
