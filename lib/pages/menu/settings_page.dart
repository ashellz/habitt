import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/functions/checkForNotifications.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

int notifValue = streakBox.get('notifValue') ?? 0;
bool uploadButtonEnabled = true;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView(
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
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Notifications",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Morning notification",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 50,
                        height: 40,
                        child: FittedBox(
                          child: Switch(
                            activeColor: theLightColor,
                            inactiveTrackColor: Colors.grey.shade800,
                            thumbColor: WidgetStateProperty.all(Colors.white),
                            value: boolBox.get('morningNotification')!,
                            onChanged: (value) {
                              setState(() {
                                boolBox.put('morningNotification', value);
                                checkForNotifications();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    onPressed: () {
                      int hour = 0;
                      int minute = 0;
                      showModalBottomSheet(
                        isDismissible: true,
                        context: context,
                        builder: (context) => 
                      );
                    },
                    child: const Text("Choose time",
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "How often should you be notified?",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          RadioListTile(
            groupValue: notifValue,
            activeColor: theLightColor,
            title: const Text(
              "Don't notify me",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            value: 0,
            onChanged: (value) {
              setState(() {
                notifValue = value!;
                streakBox.put('notifValue', value);
                boolBox.put('dailyNotification', false);
                boolBox.put('morningNotification', false);
                boolBox.put('afternoonNotification', false);
                boolBox.put('eveningNotification', false);
              });

              checkForNotifications();
            },
          ),
          RadioListTile(
            groupValue: notifValue,
            activeColor: theLightColor,
            title: const Text(
              "Once a day",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            value: 1,
            onChanged: (value) {
              setState(() {
                notifValue = value!;
                streakBox.put('notifValue', value);
                boolBox.put('dailyNotification', true);
                boolBox.put('morningNotification', false);
                boolBox.put('afternoonNotification', false);
                boolBox.put('eveningNotification', false);
              });

              checkForNotifications();
            },
          ),
          RadioListTile(
            groupValue: notifValue,
            activeColor: theLightColor,
            title: const Text(
              "Three times a day",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            value: 2,
            onChanged: (value) {
              setState(() {
                notifValue = value!;
                streakBox.put('notifValue', value);
                boolBox.put('dailyNotification', false);
                boolBox.put('morningNotification', true);
                boolBox.put('afternoonNotification', true);
                boolBox.put('eveningNotification', true);
              });

              checkForNotifications();
            },
          ),
          RadioListTile(
            groupValue: notifValue,
            activeColor: theLightColor,
            title: const Text(
              "Custom",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            value: 3,
            onChanged: (value) {
              setState(() {
                notifValue = value!;
                streakBox.put('notifValue', value);
                boolBox.put('dailyNotification', false);
                boolBox.put('morningNotification', false);
                boolBox.put('afternoonNotification', false);
                boolBox.put('eveningNotification', false);
              });

              checkForNotifications();
            },
          ),
          AnimatedContainer(
            color: Colors.black,
            duration: const Duration(milliseconds: 250),
            height: notifValue == 3 ? 60 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: notifValue == 3 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: theLightColor,
                      value: boolBox.get('morningNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('morningNotification',
                              !boolBox.get('morningNotification')!);
                        });

                        checkForNotifications();
                      },
                    ),
                    const Text(
                      "Morning notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            color: Colors.black,
            duration: const Duration(milliseconds: 250),
            height: notifValue == 3 ? 60 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: notifValue == 3 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: theLightColor,
                      value: boolBox.get('afternoonNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('afternoonNotification',
                              !boolBox.get('afternoonNotification')!);
                        });

                        checkForNotifications();
                      },
                    ),
                    const Text(
                      "Afternoon notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            color: Colors.black,
            duration: const Duration(milliseconds: 250),
            height: notifValue == 3 ? 60 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: notifValue == 3 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: theLightColor,
                      value: boolBox.get('eveningNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('eveningNotification',
                              !boolBox.get('eveningNotification')!);
                        });

                        checkForNotifications();
                      },
                    ),
                    const Text(
                      "Evening notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            color: Colors.black,
            duration: const Duration(milliseconds: 250),
            height: notifValue == 3 ? 60 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: notifValue == 3 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: theLightColor,
                      value: boolBox.get('dailyNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('dailyNotification',
                              !boolBox.get('dailyNotification')!);
                        });

                        checkForNotifications();
                      },
                    ),
                    const Text(
                      "Daily notification",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: boolBox.get("hasNotificationAccess") == false,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(theLightColor),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () => requestNotificationAccess(),
                child: const Text(
                  "Request Notification Access",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Visibility(
            visible: boolBox.get("disabledBatteryOptimization") == false,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(theLightColor),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () => disableBatteryOptimization(),
                child: const Text(
                  "Disable Battery Optimization",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Appearance",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Checkbox(
                  activeColor: theLightColor,
                  value: context.watch<HabitProvider>().displayEmptyCategories,
                  onChanged: (value) {
                    setState(() {
                      context
                          .read<HabitProvider>()
                          .updateDisplayEmptyCategories(!value!);
                    });
                  },
                ),
              ),
              const Expanded(
                flex: 6,
                child: Text(
                  "Dispay empty categories on home page",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Prefferences",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Checkbox(
                  activeColor: theLightColor,
                  value: boolBox.get("hapticFeedback"),
                  onChanged: (value) {
                    setState(() {
                      boolBox.put(
                          "hapticFeedback", !boolBox.get("hapticFeedback")!);
                    });
                  },
                ),
              ),
              const Expanded(
                flex: 6,
                child: Text(
                  "Haptic feedback (vibration)",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Checkbox(
                  activeColor: theLightColor,
                  value: boolBox.get("sound"),
                  onChanged: (value) {
                    setState(() {
                      boolBox.put("sound", !boolBox.get("sound")!);
                    });
                  },
                ),
              ),
              const Expanded(
                flex: 6,
                child: Text(
                  "Sound",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void requestNotificationAccess() {
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      boolBox.put('hasNotificationAccess', true);
    }
  });
}

void disableBatteryOptimization() async {
  bool? isBatteryOptimizationDisabled =
      await DisableBatteryOptimization.isBatteryOptimizationDisabled;
  if (isBatteryOptimizationDisabled == false) {
    await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
  } else {
    await boolBox.put('disabledBatteryOptimization', true);
  }
}
