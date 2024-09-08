import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/objects/settings/notification_container.dart';
import 'package:habit_tracker/util/objects/settings/text_and_switch_container.dart';
import 'package:provider/provider.dart';

int notifValue = streakBox.get('notifValue') ?? 0;
bool uploadButtonEnabled = true;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    disableBatteryOptimization(true, setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text("Settings",
                style: TextStyle(
                    fontSize: 42,
                    color: theLightColor,
                    fontWeight: FontWeight.bold)),
          ),
          visibilityButton(
            visible: boolBox.get('hasNotificationAccess')!,
            text: "Request Notification Access",
            func: () => requestNotificationAccess(false, setState),
          ),
          visibilityButton(
            visible: boolBox.get('disabledBatteryOptimization')!,
            text: "Disable Battery Optimization",
            func: () => disableBatteryOptimization(false, setState),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Appearance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          textAndSwitchContainer(
            "Display empty categories on home page",
            Switch(
                activeColor: theLightColor,
                inactiveTrackColor: Colors.grey.shade800,
                thumbColor: WidgetStateProperty.all(Colors.white),
                value: context.watch<HabitProvider>().displayEmptyCategories,
                onChanged: (value) {
                  context
                      .read<HabitProvider>()
                      .updateDisplayEmptyCategories(value);
                }),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Prefferences",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          textAndSwitchContainer(
            "Haptic feedback (vibration)",
            Switch(
                activeColor: theLightColor,
                inactiveTrackColor: Colors.grey.shade800,
                thumbColor: WidgetStateProperty.all(Colors.white),
                value: boolBox.get("hapticFeedback")!,
                onChanged: (value) {
                  context.read<HabitProvider>().updateHapticFeedback(value);
                }),
          ),
          textAndSwitchContainer(
            "Sound",
            Switch(
                activeColor: theLightColor,
                inactiveTrackColor: Colors.grey.shade800,
                thumbColor: WidgetStateProperty.all(Colors.white),
                value: boolBox.get("sound")!,
                onChanged: (value) {
                  context.read<HabitProvider>().updateSound(value);
                }),
          ),
          /*
          textAndSwitchContainer(
            "Ads",
            Switch(
                activeColor: theLightColor,
                inactiveTrackColor: Colors.grey.shade800,
                thumbColor: WidgetStateProperty.all(Colors.white),
                value: boolBox.get("adsEnabled")!,
                onChanged: (value) {
                  context.read<HabitProvider>().updateAds(value);
                }),
          ),*/
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Notifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          for (String category in notificationCategories)
            notificationContainer(category),
        ],
      ),
    );
  }
}

class visibilityButton extends StatelessWidget {
  const visibilityButton({
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
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(theLightColor),
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

void disableBatteryOptimization(bool start, StateSetter setState) async {
  bool? isBatteryOptimizationDisabled =
      await DisableBatteryOptimization.isBatteryOptimizationDisabled;
  if (isBatteryOptimizationDisabled == false) {
    if (!start) {
      await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }
  } else {
    setState(() async {
      await boolBox.put('disabledBatteryOptimization', true);
    });
  }
}
