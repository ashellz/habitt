import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';

bool firstValue = false;
bool secondValue = false;
bool thirdValue = false;
bool fourthValue = false;

int notifValue = 0;

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
                  notificationsBox.put('dailyNotification', false);
                  notificationsBox.put('morningNotification', false);
                  notificationsBox.put('afternoonNotification', false);
                  notificationsBox.put('eveningNotification', false);
                  notifValue = value!;
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
                      value: firstValue,
                      onChanged: (value) {
                        setState(() {
                          firstValue = value!;
                          notificationsBox.put(
                              'morningNotification', firstValue);
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
                      value: secondValue,
                      onChanged: (value) {
                        setState(() {
                          secondValue = value!;
                          notificationsBox.put(
                              'afternoonNotification', secondValue);
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
                      value: thirdValue,
                      onChanged: (value) {
                        setState(() {
                          thirdValue = value!;
                          notificationsBox.put(
                              'eveningNotification', thirdValue);
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
                      value: fourthValue,
                      onChanged: (value) {
                        setState(() {
                          fourthValue = value!;
                          notificationsBox.put(
                              'dailyNotification', fourthValue);
                        });
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
  });
}
