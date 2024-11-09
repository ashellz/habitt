import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/checkForNotifications.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

Widget chooseNotificationTime(time, StateSetter mystate, BuildContext context) {
  String timeString = "";
  int hour = 0;
  int minute = 0;
  int maxHourValue = boolBox.get("12hourFormat")! ? 12 : 23;
  int minHourValue = boolBox.get("12hourFormat")! ? 1 : 0;

  late List timeBox;

  void convertHour() {
    if (boolBox.get("12hourFormat")!) {
      if (hour > 12) {
        hour = hour - 12;
        timeString = "PM";
      } else {
        if (hour == 0) {
          hour = 12;
        }
        timeString = "AM";
      }
    }
  }

  void changeTimeString(StateSetter setState) {
    if (timeString == "AM") {
      setState(() {
        timeString = "PM";
      });
    } else {
      setState(() {
        timeString = "AM";
      });
    }
  }

  switch (time) {
    case "Morning":
      timeBox = listBox.get("morningNotificationTime")!;
      hour = timeBox[0];
      minute = timeBox[1];

      convertHour();
      break;
    case "Afternoon":
      timeBox = listBox.get("afternoonNotificationTime")!;
      hour = timeBox[0];
      minute = timeBox[1];

      convertHour();
      break;
    case "Evening":
      timeBox = listBox.get("eveningNotificationTime")!;
      hour = timeBox[0];
      minute = timeBox[1];

      convertHour();
      break;
    case "Daily":
      timeBox = listBox.get("dailyNotificationTime")!;
      hour = timeBox[0];
      minute = timeBox[1];

      convertHour();
      break;
    default:
      timeBox = time;
      hour = timeBox[0];
      minute = timeBox[1];

      convertHour();
      break;
  }

  return StatefulBuilder(
      builder: (context, setState) => Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: context.watch<ColorProvider>().greyColor,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      AppLocale.chooseTime.getString(context),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.125),
                        child: TextButton(
                            onPressed: () => changeTimeString(setState),
                            child: Text(
                              timeString,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 26),
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            axis: Axis.vertical,
                            itemHeight: 50,
                            itemWidth: 50,
                            zeroPad: true,
                            infiniteLoop: true,
                            minValue: minHourValue,
                            maxValue: maxHourValue,
                            selectedTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                            value: hour,
                            onChanged: (value) {
                              setState(() {
                                hour = value;
                              });
                            },
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: AppColors.theLightColor)),
                            ),
                          ),
                          NumberPicker(
                            axis: Axis.vertical,
                            itemHeight: 50,
                            itemWidth: 50,
                            zeroPad: true,
                            infiniteLoop: true,
                            minValue: 0,
                            maxValue: 59,
                            selectedTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                            value: minute,
                            onChanged: (value) {
                              setState(() {
                                minute = value;
                              });
                            },
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                  horizontal: BorderSide(
                                      color: AppColors.theLightColor)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            fixedSize: Size(
                                MediaQuery.of(context).size.width / 2 - 20, 50),
                          ),
                          child: Text(
                            AppLocale.cancel.getString(context),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            mystate(() {
                              late int convertedHour;

                              if (kDebugMode) {
                                print(timeString);
                              }

                              if (boolBox.get("12hourFormat")!) {
                                if (timeString == "PM") {
                                  if (hour == 12) {
                                    convertedHour = 24;
                                  } else {
                                    convertedHour = hour + 12;
                                  }
                                } else {
                                  if (hour == 12) {
                                    convertedHour = 0;
                                  } else {
                                    convertedHour = hour;
                                  }
                                }
                              } else {
                                convertedHour = hour;
                              }

                              timeBox[0] = convertedHour;
                              timeBox[1] = minute;
                            });
                            context
                                .read<HabitProvider>()
                                .updateSomethingEdited();
                            checkForNotifications();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.theLightColor,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width / 2 - 20,
                                  50)),
                          child: Text(
                            AppLocale.save.getString(context),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          ));
}
