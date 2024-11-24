import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/pages/home/widgets/additional_tasks.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';
import 'package:provider/provider.dart';

Widget tagSelectedWidget(tagSelected, editcontroller, bool isAdLoaded,
    InterstitialAd? interstitialAd, BuildContext context) {
  List habitsList = context.watch<DataProvider>().habitsList;
  int habitListLength = habitsList.length;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(translateBoth(tagSelected, context),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      for (int i = 0; i < habitListLength; i++)
        if (!habitsList[i].task)
          if (habitsList[i].category == tagSelected ||
              habitsList[i].tag == tagSelected)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: NewHabitTile(
                id: habitsList[i].id,
                editcontroller: editcontroller,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
            ),
      AdditionalTasks(
        editcontroller: editcontroller,
        isAdLoaded: isAdLoaded,
        interstitialAd: interstitialAd,
        tag: tagSelected,
      ),
      const SizedBox(height: 20),
    ],
  );
}
