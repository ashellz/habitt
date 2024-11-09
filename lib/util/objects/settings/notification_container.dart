import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/checkForNotifications.dart';
import 'package:habitt/util/objects/choose_notification_time.dart';
import 'package:provider/provider.dart';

Widget notificationContainer(String category, BuildContext context) {
  late String box;

  if (category == AppLocale.notificationMorning.getString(context)) {
    box = "morning";
  } else if (category == AppLocale.notificationAfternoon.getString(context)) {
    box = "afternoon";
  } else if (category == AppLocale.notificationEvening.getString(context)) {
    box = "evening";
  } else if (category == AppLocale.notificationDaily.getString(context)) {
    box = "daily";
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
                    "$category ${AppLocale.notification.getString(context)}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 50,
                    height: 40,
                    child: FittedBox(
                      child: Switch.adaptive(
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
                child: Text(AppLocale.chooseTime.getString(context),
                    style: const TextStyle(
                      color: Colors.white,
                    ))),
          ],
        ),
      );
    }),
  );
}
