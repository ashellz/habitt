import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/widgets/anytime_main_category.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';
import 'package:provider/provider.dart';

Widget mainCategoryList(mainCategoryHeight, mainCategory, editcontroller,
    BuildContext context, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (context.watch<DataProvider>().habitsList.isEmpty) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: double.infinity,
      child: Center(
        child: Text(
          AppLocale.nothingHere.getString(context),
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  final habitsList = context.watch<DataProvider>().habitsList;
  final habitListLength = habitsList.length;

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
                    if (habitsList[i].category == mainCategory &&
                        !habitsList[i].task)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: NewHabitTile(
                          id: habitsList[i].id,
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
                        if (habitsList[i].category == mainCategory &&
                            !habitsList[i].task)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: NewHabitTile(
                              id: habitsList[i].id,
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
                            if (habitsList[i].category == mainCategory &&
                                !habitsList[i].task)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: NewHabitTile(
                                  id: habitsList[i].id,
                                  editcontroller: editcontroller,
                                  isAdLoaded: isAdLoaded,
                                  interstitialAd: interstitialAd,
                                ),
                              ),
                        ],
                      )
                    : anyTimeMainCategory(
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
