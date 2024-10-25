import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String get bannerAdUnitId => getBannerAdUnitId();
  static String get rewardedAdUnitId => getRewardedAdUnitId();
  static String get interstitialAdUnitId => getInterstitialAdUnitId();

  static final BannerAdListener bannerAdListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (ad) {
      if (kDebugMode) {
        print('Ad loaded.');
      }
    },

    // Called when an ad request failed.
    onAdFailedToLoad: (ad, error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      if (kDebugMode) {
        print('Ad failed to load: $error');
      }
    },

    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (ad) {
      if (kDebugMode) {
        print('Ad opened.');
      }
    },

    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (ad) {
      if (kDebugMode) {
        print('Ad closed.');
      }
    },
  );
}

String getBannerAdUnitId() {
  late String id;
  if (kDebugMode) {
    if (Platform.isAndroid) {
      id = 'ca-app-pub-3940256099942544/6300978111';
    } else {
      id = 'ca-app-pub-3940256099942544/2435281174';
    }
  } else {
    if (Platform.isAndroid) {
      id = 'ca-app-pub-7884775253411884/5895461218';
    } else {
      id = 'ca-app-pub-7884775253411884/6238676769';
    }
  }
  return id;
}

String getRewardedAdUnitId() {
  late String id;

  if (kDebugMode) {
    if (Platform.isAndroid) {
      id = 'ca-app-pub-3940256099942544/5224354917';
    } else {
      id = 'ca-app-pub-3940256099942544/1712485313';
    }
  } else {
    if (Platform.isAndroid) {
      id = 'ca-app-pub-7884775253411884/9490850042';
    } else {
      id = 'ca-app-pub-7884775253411884/6396854205';
    }
  }
  return id;
}

getInterstitialAdUnitId() {
  late String id;
  if (kDebugMode) {
    if (Platform.isAndroid) {
      id = 'ca-app-pub-3940256099942544/1033173712';
    } else {
      id = 'ca-app-pub-3940256099942544/4411468910';
    }
  } else {
    if (Platform.isAndroid) {
      id = 'ca-app-pub-7884775253411884/4085703448';
    } else {
      id = 'ca-app-pub-7884775253411884/9513972139';
    }
  }
  return id;
}
