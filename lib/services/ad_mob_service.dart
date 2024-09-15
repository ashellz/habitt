import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  // Test banner id: ca-app-pub-3940256099942544/6300978111
  // Real banner id: ca-app-pub-7884775253411884/5895461218
  static String get bannerAdUnitId => "ca-app-pub-3940256099942544/6300978111";

  // Test rewarded id: ca-app-pub-3940256099942544/5224354917
  // Real rewarded id: ca-app-pub-7884775253411884/9490850042
  static String get rewardedAdUnitId =>
      "ca-app-pub-3940256099942544/5224354917";

  static final BannerAdListener bannerAdListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (ad) {
      if (!kReleaseMode) {
        print('Ad loaded.');
      }
    },

    // Called when an ad request failed.
    onAdFailedToLoad: (ad, error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      if (!kReleaseMode) {
        print('Ad failed to load: $error');
      }
    },

    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (ad) {
      if (!kReleaseMode) {
        print('Ad opened.');
      }
    },

    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (ad) {
      if (!kReleaseMode) {
        print('Ad closed.');
      }
    },
  );
}
