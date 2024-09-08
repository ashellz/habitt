import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String get bannerAdUnitId => "ca-app-pub-7884775253411884/5895461218";
  static final BannerAdListener bannerAdListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (ad) => print('Ad loaded.'),

    // Called when an ad request failed.
    onAdFailedToLoad: (ad, error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },

    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (ad) => print('Ad opened.'),

    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (ad) => print('Ad closed.'),
  );
}
