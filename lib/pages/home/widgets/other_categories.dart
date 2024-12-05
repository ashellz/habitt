import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/pages/home/widgets/category_widgets.dart';

otherCategoriesList(BuildContext context, mainCategory, editcontroller,
    bool isAdLoaded, InterstitialAd? interstitialAd) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    anyTime(context, editcontroller, mainCategory, false, isAdLoaded,
        interstitialAd),
    morning(context, mainCategory, editcontroller, false, isAdLoaded,
        interstitialAd),
    afternoon(context, mainCategory, editcontroller, false, isAdLoaded,
        interstitialAd),
    evening(context, mainCategory, editcontroller, false, isAdLoaded,
        interstitialAd),
  ]);
}
