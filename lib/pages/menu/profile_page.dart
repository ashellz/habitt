import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/ad_mob_service.dart';
import 'package:habitt/services/auth_service.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/storage_service.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/showCustomDialog.dart';
import 'package:habitt/util/objects/profile/change_username.dart';
import 'package:habitt/util/objects/profile/confirm_delete_account.dart';
import 'package:habitt/util/objects/profile/signin_method.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

bool uploadButtonEnabled = true;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final usernameFormKey = GlobalKey<FormState>();
  TextEditingController changeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  BannerAd? _banner;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();

    if (uploadButtonEnabled) {
      setState(() {
        uploadButtonEnabled = true;
      });
    }
    _createBannerAd();
    _createRewardedAd();
  }

  void _createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() => _rewardedAd = ad),
        onAdFailedToLoad: (error) => _createRewardedAd(),
      ),
    );
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createRewardedAd();
        },
      );
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        uploadData();
      });
      _rewardedAd = null;
    } else {
      uploadData();
    }
  }

  void uploadData() {
    setState(() => uploadButtonEnabled = false);

    backupHiveBoxesToFirebase(userId, false)
        .then((value) => setState(() => uploadButtonEnabled = true));
  }

  @override
  Widget build(BuildContext context) {
    void updateUsername(String newUsername) {
      setState(() {
        stringBox.put('username', newUsername);
      });
    }

    if (userId == null || FirebaseAuth.instance.currentUser!.isAnonymous) {
      return Scaffold(
        appBar:
            AppBar(backgroundColor: context.watch<ColorProvider>().blackColor),
        backgroundColor: context.watch<ColorProvider>().blackColor,
        body: Center(
          child: SignInMethod(
              icon: Bootstrap.google,
              signInFunction: AuthService().signInWithGoogle),
        ),
        bottomNavigationBar: _banner == null
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _banner!),
              ),
      );
    } else {
      return Scaffold(
        appBar:
            AppBar(backgroundColor: context.watch<ColorProvider>().blackColor),
        backgroundColor: context.watch<ColorProvider>().blackColor,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
          children: [
            Padding(
              padding: textPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profile of",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    stringBox.get("username") ?? 'Guest',
                    style: const TextStyle(
                      height: 1,
                      color: AppColors.theLightColor,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(userEmail, style: const TextStyle(fontSize: 18)),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),

            // change username

            Wrap(
                alignment: WrapAlignment.center,
                spacing: wrapSpacing(context),
                runSpacing: wrapSpacing(context),
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: context.watch<ColorProvider>().greyColor,
                      fixedSize: buttonSize(context),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () => showCustomDialog(
                        context,
                        "Change username",
                        ChangeUsernameWidget(
                          changeController: changeController,
                          formKey: usernameFormKey,
                        ), () {
                      if (usernameFormKey.currentState!.validate()) {
                        updateUsername(changeController.text);
                      }
                    }, "Confirm", "Cancel"),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Change Username",
                        style: TextStyle(
                          fontSize: fontSize(context),
                        )),
                  ),

                  // Upload data

                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: context.watch<ColorProvider>().greyColor,
                      fixedSize: buttonSize(context),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: !uploadButtonEnabled
                        ? null
                        : () {
                            showRewardedAd();
                          },
                    child: Text(
                        textAlign: TextAlign.center,
                        "Upload Data",
                        style: TextStyle(
                          fontSize: fontSize(context),
                        )),
                  ),

                  //sign out
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: context.watch<ColorProvider>().greyColor,
                      fixedSize: buttonSize(context),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () => showCustomDialog(
                        context,
                        AppLocale.signOut.getString(context),
                        Text(
                            AppLocale.dataWontBeSavedSignOut.getString(context),
                            textAlign: TextAlign.center), () {
                      AuthService().signOut(context);
                    }, AppLocale.yes.getString(context),
                        AppLocale.no.getString(context)),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Sign out",
                        style: TextStyle(
                          fontSize: fontSize(context),
                        )),
                  ),

                  // delete account

                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: context.watch<ColorProvider>().greyColor,
                      fixedSize: buttonSize(context),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                              context: context,
                              builder: (context) => confirmDeleteAccount())
                          .whenComplete(() => confirmAgain = false);
                    },
                    child: Text(
                        textAlign: TextAlign.center,
                        "Delete Account",
                        style: TextStyle(
                          fontSize: fontSize(context),
                        )),
                  ),
                ]),
            const SizedBox(height: 50),
            RichText(
              text: TextSpan(
                  style: const TextStyle(fontFamily: "Poppins"),
                  children: <TextSpan>[
                    const TextSpan(
                        text: "Joined", style: TextStyle(fontSize: 18)),
                    const TextSpan(
                        text: " habitt ",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.theLightColor)),
                    const TextSpan(
                        text: "on: ", style: TextStyle(fontSize: 18)),
                    TextSpan(
                        text:
                            "${metadataBox.get("dayJoined")!.day}.${metadataBox.get("dayJoined")!.month}.${metadataBox.get("dayJoined")!.year} ",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: _banner == null
            ? Container()
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: AdWidget(ad: _banner!),
              ),
      );
    }
  }

  Size buttonSize(BuildContext context) {
    if (MediaQuery.of(context).size.width < 360) {
      return Size(MediaQuery.of(context).size.width / 2.6,
          MediaQuery.of(context).size.width / 2.6);
    } else {
      return Size(MediaQuery.of(context).size.width / 2.4,
          MediaQuery.of(context).size.width / 2.4);
    }
  }
}

double fontSize(BuildContext context) {
  if (MediaQuery.of(context).size.width < 360) {
    return 14;
  } else {
    return 18;
  }
}

double wrapSpacing(context) {
  if (MediaQuery.of(context).size.width > 600) {
    return 50;
  } else {
    return 20;
  }
}

EdgeInsetsGeometry textPadding(context) {
  if (MediaQuery.of(context).size.width < 400) {
    return const EdgeInsets.all(6);
  } else if (MediaQuery.of(context).size.width < 600) {
    return const EdgeInsets.all(7);
  } else if (MediaQuery.of(context).size.width < 800) {
    return const EdgeInsets.all(20);
  } else {
    return const EdgeInsets.all(40);
  }
}
