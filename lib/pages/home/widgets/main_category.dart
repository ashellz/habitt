import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/main.dart';
import 'package:habitt/pages/home/widgets/anytime_main_category.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';

Widget mainCategoryList(
    habitListLength,
    mainCategoryHeight,
    mainCategory,
    editcontroller,
    BuildContext context,
    bool isAdLoaded,
    InterstitialAd? interstitialAd) {
  return Stack(
    children: [
      Container(
        height: mainCategoryHeight, // change
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theDarkGrey,
        ),
        child: mainCategory == "Morning"
            ? morningHasHabits
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 95),
                      for (int i = 0; i < habitListLength; i++)
                        if (habitBox.getAt(i)?.category == mainCategory)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: NewHabitTile(
                              index: i,
                              editcontroller: editcontroller,
                              isAdLoaded: isAdLoaded,
                              interstitialAd: interstitialAd,
                            ),
                          ),
                    ],
                  )
                : anyTimeMainCategory(habitListLength, editcontroller,
                    anytimeHasHabits, context, isAdLoaded, interstitialAd)
            : mainCategory == "Afternoon"
                ? afternoonHasHabits
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 95),
                          for (int i = 0; i < habitListLength; i++)
                            if (habitBox.getAt(i)?.category == mainCategory)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: NewHabitTile(
                                  index: i,
                                  editcontroller: editcontroller,
                                  isAdLoaded: isAdLoaded,
                                  interstitialAd: interstitialAd,
                                ),
                              ),
                        ],
                      )
                    : anyTimeMainCategory(habitListLength, editcontroller,
                        anytimeHasHabits, context, isAdLoaded, interstitialAd)
                : mainCategory == "Evening"
                    ? eveningHasHabits
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 95),
                              for (int i = 0; i < habitListLength; i++)
                                if (habitBox.getAt(i)?.category == mainCategory)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: NewHabitTile(
                                      index: i,
                                      editcontroller: editcontroller,
                                      isAdLoaded: isAdLoaded,
                                      interstitialAd: interstitialAd,
                                    ),
                                  ),
                            ],
                          )
                        : anyTimeMainCategory(
                            habitListLength,
                            editcontroller,
                            anytimeHasHabits,
                            context,
                            isAdLoaded,
                            interstitialAd)
                    : anyTimeMainCategory(habitListLength, editcontroller,
                        anytimeHasHabits, context, isAdLoaded, interstitialAd),
      ),
      Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theOtherColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            mainCategory,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}
