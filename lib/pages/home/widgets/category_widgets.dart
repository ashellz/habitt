import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/main.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';

Widget anyTime(BuildContext context, editcontroller, mainCategory, bool tag,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  int habitListLength = habitBox.length;

  String anyTime = "Any time";

  if (mainCategory != anyTime || tag) {
    if (anytimeHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translateCategory(anyTime, context),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)!.category == anyTime &&
                !habitBox.getAt(i)!.task)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  id: habitBox.getAt(i)!.id,
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
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(translateCategory(anyTime, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(AppLocale.noHabitsInCategory.getString(context),
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
      ]);
    }
  }
  return Container();
}

Widget morning(BuildContext context, mainCategory, editcontroller, bool tag,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  int habitListLength = habitBox.length;

  String morning = "Morning";

  if (mainCategory != morning || tag) {
    if (morningHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translateCategory(morning, context),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == morning &&
                !habitBox.getAt(i)!.task)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  id: habitBox.getAt(i)!.id,
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
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(translateCategory(morning, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(AppLocale.noHabitsInCategory.getString(context),
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
      ]);
    }
  }

  return Container();
}

Widget afternoon(BuildContext context, mainCategory, editcontroller, bool tag,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  int habitListLength = habitBox.length;

  String afternoon = "Afternoon";

  if (mainCategory != afternoon || tag) {
    if (afternoonHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translateCategory(afternoon, context),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == afternoon &&
                !habitBox.getAt(i)!.task)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  id: habitBox.getAt(i)!.id,
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
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(translateCategory(afternoon, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(AppLocale.noHabitsInCategory.getString(context),
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
      ]);
    }
  }
  return Container();
}

Widget evening(BuildContext context, mainCategory, editcontroller, bool tag,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  int habitListLength = habitBox.length;

  String evening = "Evening";

  if (mainCategory != evening || tag) {
    if (eveningHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translateCategory(evening, context),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == evening &&
                !habitBox.getAt(i)!.task)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  id: habitBox.getAt(i)!.id,
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
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(translateCategory(evening, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(AppLocale.noHabitsInCategory.getString(context),
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
      ]);
    }
  }
  return Container();
}
