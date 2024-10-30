import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/checkForNotifications.dart';
import 'package:habitt/util/objects/choose_notification_time.dart';
import 'package:provider/provider.dart';

Widget notificationContainer(String category) {
  late String box;

  switch (category) {
    case "Morning":
      box = "morning";
      break;
    case "Afternoon":
      box = "afternoon";
      break;
    case "Evening":
      box = "evening";
      break;
    case "Daily":
      box = "daily";
      break;
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: StatefulBuilder(builder: (context, StateSetter setState) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
            color: context.watch<ColorProvider>().greyColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: const Offset(0, -5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$category notification",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 50,
                    height: 40,
                    child: FittedBox(
                      child: Switch(
                        activeColor: AppColors.theLightColor,
                        inactiveTrackColor: Colors.grey.shade800,
                        thumbColor: WidgetStateProperty.all(Colors.white),
                        value: boolBox.get('${box}Notification')!,
                        onChanged: (value) {
                          setState(() {
                            boolBox.put('${box}Notification', value);
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
                  showModalBottomSheet(
                      enableDrag: false,
                      context: context,
                      builder: (context) =>
                          chooseNotificationTime(category, setState, context));
                },
                child: const Text("Choose time",
                    style: TextStyle(
                      color: Colors.white,
                    ))),
          ],
        ),
      );
    }),
  );
}
