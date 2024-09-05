import 'package:flutter/material.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/objects/habit/choose_notification_time.dart';
import 'package:provider/provider.dart';

List editHabitNotifications = [];

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    editHabitNotifications = context.watch<HabitProvider>().habitNotifications;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        children: [
          const Text(
            "Habit Notifications",
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          for (List<int> notification in editHabitNotifications)
            Column(
              children: [
                notificationTile(notification, context),
                const SizedBox(height: 20.0),
              ],
            ),
          IconButton(
              icon: const Icon(Icons.add, color: Colors.grey, size: 32),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(theDarkGrey),
              ),
              onPressed: () {
                setState(() {
                  editHabitNotifications.add([0, 0]);
                });
              }),
        ],
      ),
    );
  }
}

Widget notificationTile(List<int> notification, context) {
  return StatefulBuilder(
      builder: (BuildContext context, StateSetter mystate) => Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                  padding: const EdgeInsets.all(20.0),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: theColor, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 44,
                        ),
                        TextButton(
                            style: ButtonStyle(
                              overlayColor: WidgetStatePropertyAll(theColor),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => chooseNotificationTime(
                                      notification, mystate));
                            },
                            child: Text(
                              "${notification[0] < 10 ? "0${notification[0]}" : notification[0]}:${notification[1] < 10 ? "0${notification[1]}" : notification[1]}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )),
                        timeFormat == 12
                            ? const Text(
                                "AM",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            : const SizedBox(
                                width: 50,
                              ),
                      ])),
              IconButton(
                onPressed: () {
                  context
                      .read<HabitProvider>()
                      .removeNotification(notification);
                },
                highlightColor: theDarkColor,
                icon: const Icon(Icons.close),
                color: Colors.white,
              ),
            ],
          ));
}
