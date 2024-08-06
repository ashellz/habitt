import 'package:flutter/material.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    List habitNotifications = context.watch<HabitProvider>().habitNotifications;

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
          for (List<int> notification in habitNotifications)
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
                  habitNotifications.add([0, 0]);
                });
              }),
        ],
      ),
    );
  }
}

Widget notificationTile(List<int> notification, context) {
  int notificationHour = notification[0];
  int notificationMinute = notification[1];

  return StatefulBuilder(
      builder: (BuildContext context, StateSetter mystate) => Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                  padding: const EdgeInsets.all(20.0),
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: theColor, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 44,
                        ),
                        const SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Hour",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  NumberPicker(
                                      zeroPad: true,
                                      haptics: true,
                                      infiniteLoop: true,
                                      itemHeight: 40,
                                      itemWidth: 40,
                                      minValue: 0,
                                      maxValue: 23,
                                      value: notificationHour,
                                      axis: Axis.horizontal,
                                      selectedTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onChanged: (value) {
                                        mystate(() {
                                          notificationHour = value;
                                          notification[0] =
                                              value; //this is updated right to habitBox
                                        });
                                      })
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Minute",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  NumberPicker(
                                      zeroPad: true,
                                      haptics: true,
                                      infiniteLoop: true,
                                      itemHeight: 40,
                                      itemWidth: 40,
                                      minValue: 0,
                                      maxValue: 59,
                                      value: notificationMinute,
                                      axis: Axis.horizontal,
                                      selectedTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onChanged: (value) {
                                        mystate(() {
                                          notificationMinute = value;

                                          notification[1] =
                                              value; //this is updated right to habitBox
                                        });
                                      })
                                ],
                              ),
                            ),
                          ],
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
