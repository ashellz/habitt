import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/shared%20widgets/expandable_app_bar.dart';
import 'package:habitt/services/provider/habit_provider.dart';
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
    return Scaffold(
      backgroundColor: theBlackColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          ExpandableAppBar(actionsWidget: Container(), title: "Settings"),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    "Appearance",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                textAndSwitchContainer(
                  "Display empty categories on home page",
                  Switch.adaptive(
                      activeColor: theLightColor,
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
                  Switch.adaptive(
                      activeColor: theLightColor,
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
                  "Sound",
                  Switch.adaptive(
                      activeColor: theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: boolBox.get("sound")!,
                      onChanged: (value) {
                        context.read<HabitProvider>().updateSound(value);
                      }),
                ),
                textAndSwitchContainer(
                  "12-hour format",
                  Switch.adaptive(
                      activeColor: theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: boolBox.get("12hourFormat")!,
                      onChanged: (value) {
                        context.read<HabitProvider>().updateHourFormat(value);
                      }),
                ),
                textAndSwitchContainer(
                  "Edit habit in the past",
                  Switch.adaptive(
                      activeColor: theLightColor,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: WidgetStateProperty.all(Colors.white),
                      value: boolBox.get("editHistoricalHabits")!,
                      onChanged: (value) {
                        context
                            .read<HabitProvider>()
                            .updateEditHistoricalHabits(value);
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                for (String category in notificationCategories)
                  notificationContainer(category),
                VisibilityButton(
                  visible: boolBox.get('hasNotificationAccess')!,
                  text: "Request Notification Access",
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
