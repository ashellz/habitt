import 'package:flutter/material.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:numberpicker/numberpicker.dart';

Widget chooseTime() {
  return StatefulBuilder(
      builder: (context, setState) => Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.grey.shade900,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Choose time",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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
                        minValue: 0,
                        maxValue: 23,
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
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                              horizontal: BorderSide(color: theLightColor)),
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
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                              horizontal: BorderSide(color: theLightColor)),
                        ),
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
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theLightColor,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width / 2 - 20,
                                  50)),
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          ));
}
