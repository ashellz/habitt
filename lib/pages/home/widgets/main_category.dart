import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/pages/home/widgets/anytime_main_category.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';
import 'package:provider/provider.dart';

Widget mainCategoryList(
    habitListLength,
    mainCategoryHeight,
    mainCategory,
    editcontroller,
    BuildContext context,
    bool isAdLoaded,
    InterstitialAd? interstitialAd) {
  if (context.watch<DataProvider>().habitsList.isEmpty) {
    return Text(
      "Nothing to see here.",
      textAlign: TextAlign.center,
    ); // TODO: edit this later
  }
  return Stack(
    children: [
      Container(
        height: mainCategoryHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.watch<ColorProvider>().darkGreyColor,
        ),
        child: mainCategory == "Morning"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 95),
                  for (int i = 0; i < habitListLength; i++)
                    if (habitBox.getAt(i)?.category == mainCategory &&
                        !habitBox.getAt(i)!.task)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: NewHabitTile(
                          id: habitBox.getAt(i)!.id,
                          editcontroller: editcontroller,
                          isAdLoaded: isAdLoaded,
                          interstitialAd: interstitialAd,
                        ),
                      ),
                ],
              )
            : mainCategory == "Afternoon"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 95),
                      for (int i = 0; i < habitListLength; i++)
                        if (habitBox.getAt(i)?.category == mainCategory &&
                            !habitBox.getAt(i)!.task)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: NewHabitTile(
                              id: habitBox.getAt(i)!.id,
                              editcontroller: editcontroller,
                              isAdLoaded: isAdLoaded,
                              interstitialAd: interstitialAd,
                            ),
                          ),
                    ],
                  )
                : mainCategory == "Evening"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 95),
                          for (int i = 0; i < habitListLength; i++)
                            if (habitBox.getAt(i)?.category == mainCategory &&
                                !habitBox.getAt(i)!.task)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: NewHabitTile(
                                  id: habitBox.getAt(i)!.id,
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
                        true,
                        context,
                        isAdLoaded,
                        interstitialAd,
                      ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.theOtherColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            translateCategory(mainCategory, context),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}
