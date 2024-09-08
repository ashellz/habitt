import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/ad_mob_service.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/objects/profile/confirm_delete_account.dart';
import 'package:habit_tracker/util/objects/profile/confirm_sign_out.dart';
import 'package:habit_tracker/util/objects/profile/change_username.dart';

bool uploadButtonEnabled = true;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  BannerAd? _banner;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    void updateUsername(changeUsernameController) {
      setState(() {
        stringBox.put('username', changeUsernameController);
      });
    }

    /*
    Future<void> updateEmail(changeEmailController, password) async {
      await AuthService()
          .updateEmail(userEmail, password, changeEmailController);
    }*/

    if (userId == null || FirebaseAuth.instance.currentUser!.isAnonymous) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You are not logged in. ',
                  style: TextStyle(fontSize: 18)),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                ),
                child: const Text("Log in?",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )
            ],
          )),
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
        appBar: AppBar(backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        body: ListView(
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
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      stringBox.get("username") ?? 'Guest',
                      style: TextStyle(
                        color: theLightColor,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Transform.translate(
                      offset: const Offset(0, -15),
                      child: Text(userEmail,
                          style: const TextStyle(fontSize: 18))),
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
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: buttonSize(context),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: theLightColor, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          changeController.text = "";
                          passwordController.text = "";
                          return changeUsernameDialog(
                              context, "Change username", updateUsername);
                        }),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Change Username",
                        style: TextStyle(
                          fontSize: fontSize(context),
                        )),
                  ),

                  // Upload data

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: buttonSize(context),
                      disabledForegroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: theLightColor, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: !uploadButtonEnabled
                        ? null
                        : () {
                            setState(() => uploadButtonEnabled = false);
                            backupHiveBoxesToFirebase(userId).whenComplete(() =>
                                setState(() => uploadButtonEnabled = true));
                          },
                    child: Text(
                        textAlign: TextAlign.center,
                        "Upload Data",
                        style: TextStyle(
                          fontSize: fontSize(context),
                        )),
                  ),

                  //sign out
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: buttonSize(context),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: theYellowColor, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => confirmSignOut(context)),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Sign out",
                        style: TextStyle(
                          fontSize: fontSize(context),
                        )),
                  ),

                  // delete account

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: buttonSize(context),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: theRedColor, width: 3),
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
