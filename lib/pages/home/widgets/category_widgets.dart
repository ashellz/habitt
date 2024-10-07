import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/main.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';
import 'package:provider/provider.dart';

Widget anyTime(BuildContext context, editcontroller, mainCategory, bool tag,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  List habitsList = context.watch<HabitProvider>().habitsList;
  int habitListLength = habitsList.length;

  if (mainCategory != 'Any time' || tag) {
    if (anytimeHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Any time",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)!.category == 'Any time')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  index: i,
                  editcontroller: editcontroller,
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
  }
  return Container();
}

Widget morning(BuildContext context, mainCategory, editcontroller, bool tag,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  int habitListLength = context.watch<HabitProvider>().habitsList.length;
  if (mainCategory != 'Morning' || tag) {
    if (morningHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Morning",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == 'Morning')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  index: i,
                  editcontroller: editcontroller,
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
  }

  return Container();
}

Widget afternoon(BuildContext context, mainCategory, editcontroller, bool tag,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  int habitListLength = context.watch<HabitProvider>().habitsList.length;
  if (mainCategory != 'Afternoon' || tag) {
    if (afternoonHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Afternoon",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == 'Afternoon')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  index: i,
                  editcontroller: editcontroller,
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
  }
  return Container();
}

Widget evening(BuildContext context, mainCategory, editcontroller, bool tag,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  int habitListLength = context.watch<HabitProvider>().habitsList.length;
  if (mainCategory != 'Evening' || tag) {
    if (eveningHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Evening",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == 'Evening')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  index: i,
                  editcontroller: editcontroller,
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
  }
  return Container();
}
