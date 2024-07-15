import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/storage_service.dart';

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
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "Notifications (in development)",
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
              title: const Text(
                "Three times a day",
                style: TextStyle(color: Colors.black, fontSize: 16),
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
              title: const Text(
                "Custom",
                style: TextStyle(color: Colors.black, fontSize: 16),
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
                      value: boolBox.get('morningNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('morningNotification',
                              !boolBox.get('morningNotification')!);
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
                      value: boolBox.get('afternoonNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('afternoonNotification',
                              !boolBox.get('afternoonNotification')!);
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
                      value: boolBox.get('eveningNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('eveningNotification',
                              !boolBox.get('eveningNotification')!);
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
                      value: boolBox.get('dailyNotification'),
                      onChanged: (value) {
                        setState(() {
                          boolBox.put('dailyNotification',
                              !boolBox.get('dailyNotification')!);
                        });
                        print(boolBox.get('dailyNotification'));
                      },
                    ),
                    const Text("Daily notification"),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "Data",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Upload Data Manually",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                    onPressed: !uploadButtonEnabled
                        ? null
                        : () async {
                            if (userId == null) {
                              Fluttertoast.showToast(
                                msg: 'You are not logged in.',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                backgroundColor: Colors.black54,
                                textColor: Colors.white,
                                fontSize: 14.0,
                              );
                            } else {
                              setState(() => uploadButtonEnabled = false);
                              await backupHiveBoxesToFirebase(userId);
                            }
                          },
                    icon: const Icon(Icons.upload)),
              ),
            ],
          ),
          const Spacer(),
          Visibility(
            visible: boolBox.get("hasNotificationAccess") == false,
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
