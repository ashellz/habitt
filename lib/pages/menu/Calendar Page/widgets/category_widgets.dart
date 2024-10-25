import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/menu/Calendar%20Page/functions/historicalHasHabits.dart';
import 'package:habitt/util/objects/habit/calendar_habit_tile.dart';

Widget anyTime(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (historicalHasHabits("Any time", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Any time",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (historicalBox.getAt(boxIndex)!.data[i].category == 'Any time' &&
              !historicalBox.getAt(boxIndex)!.data[i].task)
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
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Any time",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
        ]);
  }

  return const SizedBox(height: 0);
}

Widget morning(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (historicalHasHabits("Morning", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Morning",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (historicalBox.getAt(boxIndex)!.data[i].category == 'Morning' &&
              !historicalBox.getAt(boxIndex)!.data[i].task)
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
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Morning",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
        ]);
  }

  return const SizedBox(height: 0);
}

Widget afternoon(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (historicalHasHabits("Afternoon", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Afternoon",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (historicalBox.getAt(boxIndex)!.data[i].category == 'Afternoon' &&
              !historicalBox.getAt(boxIndex)!.data[i].task)
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
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Afternoon",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
        ]);
  }

  return const SizedBox(height: 0);
}

Widget evening(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (historicalHasHabits("Evening", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Evening",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (historicalBox.getAt(boxIndex)!.data[i].category == 'Evening' &&
              !historicalBox.getAt(boxIndex)!.data[i].task)
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
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Evening",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
        ]);
  }

  return const SizedBox(height: 0);
}
