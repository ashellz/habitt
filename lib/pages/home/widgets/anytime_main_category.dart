import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';

Widget anyTimeMainCategory(
    int habitListLength,
    editcontroller,
    anyTimeHasHabits,
    BuildContext context,
    bool isAdLoaded,
    InterstitialAd? interstitialAd) {
  if (anyTimeHasHabits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 95),
        for (int i = 0; i < habitListLength; i++)
          if (habitBox.getAt(i)?.category == "Any time")
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
    );
  } else {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theDarkGrey,
      ),
      child: const Padding(
        padding: EdgeInsets.only(left: 20, top: 65),
        child: Text(
          "No habits in this category",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
