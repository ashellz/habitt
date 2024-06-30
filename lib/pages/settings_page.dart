import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';

int notifValue = streakBox.get('notifValue') ?? 0;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 211, 190),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        toolbarHeight: 80.0,
        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: Text(
              "Notifications",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "How often should you be notified?",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RadioListTile(
              groupValue: notifValue,
              title: const Text(
                "Once a day",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              value: 0,
              onChanged: (value) {
                setState(() {
                  notifValue = value!;
                  streakBox.put('notifValue', value);
                  notificationsBox.put('dailyNotification', true);
                  notificationsBox.put('morningNotification', false);
                  notificationsBox.put('afternoonNotification', false);
                  notificationsBox.put('eveningNotification', false);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RadioListTile(
              groupValue: notifValue,
              title: const Text(
                "Three times a day",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              value: 1,
              onChanged: (value) {
                setState(() {
                  notifValue = value!;
                  streakBox.put('notifValue', value);
                  notificationsBox.put('dailyNotification', false);
                  notificationsBox.put('morningNotification', true);
                  notificationsBox.put('afternoonNotification', true);
                  notificationsBox.put('eveningNotification', true);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RadioListTile(
              groupValue: notifValue,
              title: const Text(
                "Custom",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              value: 2,
              onChanged: (value) {
                setState(() {
                  notifValue = value!;
                  streakBox.put('notifValue', value);
                  notificationsBox.put('dailyNotification', false);
                  notificationsBox.put('morningNotification', false);
                  notificationsBox.put('afternoonNotification', false);
                  notificationsBox.put('eveningNotification', false);
                });
              },
            ),
          ),
          AnimatedContainer(
            color: const Color.fromARGB(255, 218, 211, 190),
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
                      value: notificationsBox.get('morningNotification'),
                      onChanged: (value) {
                        setState(() {
                          notificationsBox.put('morningNotification',
                              !notificationsBox.get('morningNotification')!);
                        });
                      },
                    ),
                    const Text("Morning notification"),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            color: const Color.fromARGB(255, 218, 211, 190),
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
                      value: notificationsBox.get('afternoonNotification'),
                      onChanged: (value) {
                        setState(() {
                          notificationsBox.put('afternoonNotification',
                              !notificationsBox.get('afternoonNotification')!);
                        });
                      },
                    ),
                    const Text("Afternoon notification"),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            color: const Color.fromARGB(255, 218, 211, 190),
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
                      value: notificationsBox.get('eveningNotification'),
                      onChanged: (value) {
                        setState(() {
                          notificationsBox.put('eveningNotification',
                              !notificationsBox.get('eveningNotification')!);
                        });
                      },
                    ),
                    const Text("Evening notification"),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            color: const Color.fromARGB(255, 218, 211, 190),
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
                      value: notificationsBox.get('dailyNotification'),
                      onChanged: (value) {
                        setState(() {
                          notificationsBox.put('dailyNotification',
                              !notificationsBox.get('dailyNotification')!);
                        });
                        print(notificationsBox.get('dailyNotification'));
                      },
                    ),
                    const Text("Daily notification"),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Visibility(
            visible: notificationsBox.get("hasNotificationAccess") == false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 183, 181, 151)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () => requestNotificationAccess(),
                  child: const Text(
                    "Request Notification Access",
                    style: TextStyle(color: Colors.black, fontSize: 16),
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
