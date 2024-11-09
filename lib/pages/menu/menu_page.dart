import "package:flutter/material.dart";
import "package:flutter_localization/flutter_localization.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:habitt/data/app_locale.dart";
import "package:habitt/pages/menu/Calendar%20Page/calendar_page.dart";
import "package:habitt/pages/menu/changelog_page.dart";
import "package:habitt/pages/menu/profile_page.dart";
import "package:habitt/pages/menu/settings_page.dart";
import "package:habitt/services/ad_mob_service.dart";
import "package:habitt/services/provider/color_provider.dart";
import "package:habitt/services/provider/habit_provider.dart";
import "package:habitt/util/colors.dart";
import "package:provider/provider.dart";

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
    return Scaffold(
      appBar:
          AppBar(backgroundColor: context.watch<ColorProvider>().blackColor),
      backgroundColor: context.watch<ColorProvider>().blackColor,
      body: Stack(
        children: [
          buildHeader(context),
          buildMenuItems(context),
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

Widget buildHeader(BuildContext context) {
  int streak = context.watch<HabitProvider>().allHabitsCompletedStreak;
  return Padding(
    padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppLocale.allHabitsCompletedStreak.getString(context),
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            streak == 1
                ? "$streak ${AppLocale.day.getString(context)}"
                : "$streak ${AppLocale.days.getString(context)}",
            style: const TextStyle(
                color: AppColors.theLightColor,
                fontSize: 42,
                fontWeight: FontWeight.bold),
          ),
        ]),
  );
}

Widget buildMenuItems(BuildContext context) => Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
                leading: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 25,
                ),
                title: Text(
                  AppLocale.calendar.getString(context),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarPage(),
                      ),
                    )),
            ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25,
                ),
                title: Text(
                  AppLocale.settings.getString(context),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    )),
            ListTile(
                leading: const Icon(
                  Icons.update,
                  color: Colors.white,
                  size: 25,
                ),
                title: Text(
                  AppLocale.changelog.getString(context),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangelogPage(),
                      ),
                    )),
            ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 25,
                ),
                title: Text(
                  AppLocale.profile.getString(context),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    ))
          ],
        ),
      ),
    );
