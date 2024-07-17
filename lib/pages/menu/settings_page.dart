import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';

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
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: Text("Settings",
                style: TextStyle(
                    fontSize: 42,
                    color: theLightGreen,
                    fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "Notifications (in development)",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "How often should you be notified?",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RadioListTile(
              groupValue: notifValue,
              activeColor: theLightGreen,
              title: const Text(
                "Once a day",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              value: 0,
              onChanged: (value) {
                setState(() {
                  notifValue = value!;
                  streakBox.put('notifValue', value);
                  boolBox.put('dailyNotification', true);
                  boolBox.put('morningNotification', false);
                  boolBox.put('afternoonNotification', false);
                  boolBox.put('eveningNotification', false);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RadioListTile(
              groupValue: notifValue,
              activeColor: theLightGreen,
              title: const Text(
                "Three times a day",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              value: 1,
              onChanged: (value) {
                setState(() {
                  notifValue = value!;
                  streakBox.put('notifValue', value);
                  boolBox.put('dailyNotification', false);
                  boolBox.put('morningNotification', true);
                  boolBox.put('afternoonNotification', true);
                  boolBox.put('eveningNotification', true);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RadioListTile(
              groupValue: notifValue,
              activeColor: theLightGreen,
              title: const Text(
                "Custom",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              value: 2,
              onChanged: (value) {
                setState(() {
                  notifValue = value!;
                  streakBox.put('notifValue', value);
                  boolBox.put('dailyNotification', false);
                  boolBox.put('morningNotification', false);
                  boolBox.put('afternoonNotification', false);
                  boolBox.put('eveningNotification', false);
                });
              },
            ),
          ),
          AnimatedContainer(
            color: Colors.black,
            duration: const Duration(milliseconds: 250),
            height: notifValue == 2 ? 60 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: notifValue == 2 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 43),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: theLightGreen,
                      value: boolBox.get('morningNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('morningNotification',
                              !boolBox.get('morningNotification')!);
                        });
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
            height: notifValue == 2 ? 60 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: notifValue == 2 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 43),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: theLightGreen,
                      value: boolBox.get('afternoonNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('afternoonNotification',
                              !boolBox.get('afternoonNotification')!);
                        });
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
            height: notifValue == 2 ? 60 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: notifValue == 2 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 43),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: theLightGreen,
                      value: boolBox.get('eveningNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('eveningNotification',
                              !boolBox.get('eveningNotification')!);
                        });
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
            height: notifValue == 2 ? 60 : 0,
            curve: Curves.fastOutSlowIn,
            child: AnimatedOpacity(
              opacity: notifValue == 2 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 43),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: theLightGreen,
                      value: boolBox.get('dailyNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('dailyNotification',
                              !boolBox.get('dailyNotification')!);
                        });
                        print(boolBox.get('dailyNotification'));
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
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: Center(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(theLightGreen),
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
    }
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1234,
            channelKey: 'basic_channel',
            title: 'Basic Notification',
            body: 'Notification Body'));
  });
}
