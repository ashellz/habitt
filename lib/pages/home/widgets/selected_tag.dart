import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';

Widget tagSelectedWidget(tagSelected, editcontroller, bool isAdLoaded,
    InterstitialAd? interstitialAd) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(tagSelected,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      for (int i = 0; i < habitBox.length; i++)
        if (habitBox.getAt(i)?.category == tagSelected ||
            habitBox.getAt(i)?.tag == tagSelected)
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
