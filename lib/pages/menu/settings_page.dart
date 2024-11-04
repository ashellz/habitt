import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/shared%20widgets/expandable_app_bar.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/services/provider/language_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/objects/settings/notification_container.dart';
import 'package:habitt/util/objects/settings/text_and_switch_container.dart';
import 'package:provider/provider.dart';

int notifValue = streakBox.get('notifValue') ?? 0;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool onInit = true;
  List<String> notificationCategories = [
    "Morning",
    "Afternoon",
    "Evening",
    "Daily"
  ];

  @override
  void initState() {
    super.initState();

    requestNotificationAccess(true, setState);
  }

  @override
  Widget build(BuildContext context) {
    if (onInit) {
      notificationCategories = [
        AppLocale.notificationMorning.getString(context),
        AppLocale.notificationAfternoon.getString(context),
        AppLocale.notificationEvening.getString(context),
        AppLocale.notificationDaily.getString(context),
      ];

      onInit = false;
    }

    return Scaffold(
      backgroundColor: context.watch<ColorProvider>().blackColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          ExpandableAppBar(
              actionsWidget: TextButton(
                  onPressed: () {
                    var languageProvider =
                        Provider.of<LanguageProvider>(context, listen: false);
                    final newLanguage =
                        languageProvider.languageCode == 'en' ? 'ba' : 'en';
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      languageProvider.changeLanguage(newLanguage);
                    });

                    onInit = true;
                  },
                  child: Text(
                      context
                          .watch<LanguageProvider>()
                          .languageCode
                          .toUpperCase(),
                      style: const TextStyle(color: Colors.white))),
              title: AppLocale.settings.getString(context)),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    AppLocale.appearance.getString(context),
                    key: ValueKey<String>(
                        AppLocale.appearance.getString(context)),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                textAndSwitchContainer(
                  AppLocale.displayEmptyCategories.getString(context),
                  Switch.adaptive(
                      activeColor: AppColors.theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value:
                          context.watch<HabitProvider>().displayEmptyCategories,
                      onChanged: (value) {
                        context
                            .read<HabitProvider>()
                            .updateDisplayEmptyCategories(value);
                      }),
                ),
                textAndSwitchContainer(
                  AppLocale.blackMode.getString(context),
                  Switch.adaptive(
                      activeColor: AppColors.theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: context.watch<ColorProvider>().isTrueBlack,
                      onChanged: (value) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<ColorProvider>().updateDarkColor(value);
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    AppLocale.preferences.getString(context),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                textAndSwitchContainer(
                  AppLocale.hapticFeedback.getString(context),
                  Switch.adaptive(
                      activeColor: AppColors.theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: boolBox.get("hapticFeedback")!,
                      onChanged: (value) {
                        context
                            .read<HabitProvider>()
                            .updateHapticFeedback(value);
                      }),
                ),
                textAndSwitchContainer(
                  AppLocale.sound.getString(context),
                  Switch.adaptive(
                      activeColor: AppColors.theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: boolBox.get("sound")!,
                      onChanged: (value) {
                        context.read<HabitProvider>().updateSound(value);
                      }),
                ),
                textAndSwitchContainer(
                  AppLocale.hourFormat.getString(context),
                  Switch.adaptive(
                      activeColor: AppColors.theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: boolBox.get("12hourFormat")!,
                      onChanged: (value) {
                        context.read<HabitProvider>().updateHourFormat(value);
                      }),
                ),
                textAndSwitchContainer(
                  AppLocale.editHabitInThePast.getString(context),
                  Switch.adaptive(
                      activeColor: AppColors.theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: boolBox.get("editHistoricalHabits")!,
                      onChanged: (value) {
                        context
                            .read<HabitProvider>()
                            .updateEditHistoricalHabits(value);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    AppLocale.notifications.getString(context),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                for (String category in notificationCategories)
                  notificationContainer(category, context),
                VisibilityButton(
                  visible: boolBox.get('hasNotificationAccess')!,
                  text: AppLocale.requestNotificationAccess.getString(context),
                  func: () => requestNotificationAccess(false, setState),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class VisibilityButton extends StatelessWidget {
  const VisibilityButton({
    super.key,
    required this.visible,
    required this.func,
    required this.text,
  });

  final bool visible;
  final Function func;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible == false,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColors.theLightColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: func as void Function(),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

void requestNotificationAccess(bool start, StateSetter setState) {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      if (!start) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    } else {
      setState(() async {
        await boolBox.put('hasNotificationAccess', true);
      });
    }
  });
}
