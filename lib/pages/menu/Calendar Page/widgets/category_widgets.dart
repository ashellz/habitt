import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/menu/Calendar%20Page/functions/historicalHasHabits.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:habitt/util/objects/habit/calendar_habit_tile.dart';
import 'package:provider/provider.dart';

Widget anyTime(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  const String category = 'Any time';

  if (historicalHasHabits(category, habitsOnDate, habitListLength)) {
    habitsOnDate = context.watch<HistoricalHabitProvider>().historicalHabits;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translateCategory(category, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitsOnDate[i].category == category && !habitsOnDate[i].task)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                index: i,
                habits: habitsOnDate,
                time: today,
                boxIndex: boxIndex,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
            ),
        const SizedBox(height: 20),
      ],
    );
  }
  if (boolBox.get("displayEmptyCategories")!) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(translateCategory(category, context),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(AppLocale.noHabitsInCategory.getString(context),
          style: const TextStyle(fontSize: 18, color: Colors.grey)),
      const SizedBox(height: 20),
    ]);
  }

  return const SizedBox(height: 0);
}

Widget morning(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  const String category = 'Morning';

  if (historicalHasHabits(morning, habitsOnDate, habitListLength)) {
    habitsOnDate = context.watch<HistoricalHabitProvider>().historicalHabits;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translateCategory(category, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitsOnDate[i].category == category && !habitsOnDate[i].task)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                index: i,
                habits: habitsOnDate,
                time: today,
                boxIndex: boxIndex,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
            ),
        const SizedBox(height: 20),
      ],
    );
  }

  if (boolBox.get("displayEmptyCategories")!) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(translateCategory(category, context),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(AppLocale.noHabitsInCategory.getString(context),
          style: const TextStyle(fontSize: 18, color: Colors.grey)),
      const SizedBox(height: 20),
    ]);
  }

  return const SizedBox(height: 0);
}

Widget afternoon(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  const String category = 'Afternoon';

  if (historicalHasHabits(category, habitsOnDate, habitListLength)) {
    habitsOnDate = context.watch<HistoricalHabitProvider>().historicalHabits;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translateCategory(category, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitsOnDate[i].category == category && !habitsOnDate[i].task)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                index: i,
                habits: habitsOnDate,
                time: today,
                boxIndex: boxIndex,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
            ),
        const SizedBox(height: 20),
      ],
    );
  }

  if (boolBox.get("displayEmptyCategories")!) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(translateCategory(category, context),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(AppLocale.noHabitsInCategory.getString(context),
          style: const TextStyle(fontSize: 18, color: Colors.grey)),
      const SizedBox(height: 20),
    ]);
  }

  return const SizedBox(height: 0);
}

Widget evening(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  const String category = 'Evening';

  if (historicalHasHabits(category, habitsOnDate, habitListLength)) {
    habitsOnDate = context.watch<HistoricalHabitProvider>().historicalHabits;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translateCategory(category, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitsOnDate[i].category == category && !habitsOnDate[i].task)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                index: i,
                habits: habitsOnDate,
                time: today,
                boxIndex: boxIndex,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
            ),
        const SizedBox(height: 20),
      ],
    );
  }

  if (boolBox.get("displayEmptyCategories")!) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(translateCategory(category, context),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text(AppLocale.noHabitsInCategory.getString(context),
          style: const TextStyle(fontSize: 18, color: Colors.grey)),
      const SizedBox(height: 20),
    ]);
  }

  return const SizedBox(height: 0);
}
