import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';

Widget tagSelectedWidget(tagSelected, editcontroller, bool isAdLoaded,
    InterstitialAd? interstitialAd, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(translateCategory(tagSelected, context),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      for (int i = 0; i < habitBox.length; i++)
        if (habitBox.getAt(i)?.category == tagSelected &&
                !habitBox.getAt(i)!.task ||
            habitBox.getAt(i)?.tag == tagSelected && !habitBox.getAt(i)!.task)
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
