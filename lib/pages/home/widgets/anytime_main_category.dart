import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';
import 'package:provider/provider.dart';

Widget anyTimeMainCategory(editcontroller, anyTimeHasHabits,
    BuildContext context, bool isAdLoaded, InterstitialAd? interstitialAd) {
  List habitsList = context.watch<DataProvider>().habitsList;
  int habitListLength = habitsList.length;
  if (anyTimeHasHabits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 95),
        for (int i = 0; i < habitListLength; i++)
          if (habitsList[i].category == "Any time" && !habitsList[i].task)
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
    );
  } else {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: context.watch<ColorProvider>().darkGreyColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 65),
        child: Text(
          AppLocale.noHabitsInCategory.getString(context),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
