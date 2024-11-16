import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/validate_text.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HabitType extends StatefulWidget {
  const HabitType({
    super.key,
    required this.isEdit,
  });

  final bool isEdit;

  @override
  State<HabitType> createState() => _HabitNameTextFieldState();
}

class _HabitNameTextFieldState extends State<HabitType> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: TextFormField(
        onTap: () => showChooseHabitType(context, widget.isEdit),
        keyboardAppearance: Theme.of(context).brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
        inputFormatters: [
          LengthLimitingTextInputFormatter(35),
        ],
        readOnly: true,
        cursorColor: Colors.white,
        cursorWidth: 2.0,
        cursorHeight: 22.0,
        cursorRadius: const Radius.circular(10.0),
        cursorOpacityAnimates: true,
        enableInteractiveSelection: true,
        validator: validateText,
        controller: context.watch<DataProvider>().habitTypeController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          labelStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.theLightColor),
          labelText: AppLocale.habitType.getString(context),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: context.watch<ColorProvider>().greyColor,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                showChooseHabitType(context, widget.isEdit);
              },
              icon: const Icon(
                Icons.calendar_month,
              ),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

void showChooseHabitType(BuildContext context, bool isEdit) {
  int valueSelected = 0;
  List<String> options = ["Daily", "Weekly", "Monthly", "Custom"];
  List<String> values = [
    "Once",
    "Twice",
    "Three days",
    "Four days",
    "Five days",
    "Six days"
  ];

  List<bool> selectedDaysAWeek = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  void showHabitTypeOptions(BuildContext context, String type) {
    bool showMoreOptionsWeekly = false;

    showModalBottomSheet(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (context, StateSetter setState) {
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 10, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.theLightColor)),
                  const SizedBox(height: 15),
                  if (type == "Weekly")
                    Column(
                      children: [
                        Row(
                          children: [
                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(context
                                            .watch<ColorProvider>()
                                            .greyColor)),
                                onPressed: () {
                                  if (valueSelected == 5) {
                                    setState(() {
                                      valueSelected = 0;
                                    });
                                  } else {
                                    setState(() {
                                      valueSelected++;
                                    });
                                  }
                                },
                                child: Text(
                                  values[valueSelected],
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                )),
                            const Text(
                              " a week.",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "This habit will appear ${values[valueSelected].toLowerCase()} a week until completed${valueSelected == 0 ? "." : " ${valueSelected + 1} times."}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        ListTile(
                            onTap: () => setState(() {
                                  showMoreOptionsWeekly =
                                      !showMoreOptionsWeekly;
                                }),
                            splashColor: Colors.transparent,
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text("More options"),
                            trailing: Icon(showMoreOptionsWeekly
                                ? Icons.expand_less
                                : Icons.expand_more)),
                        if (showMoreOptionsWeekly)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Select days for this habit:"),
                              const SizedBox(height: 5),
                              Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      context.watch<ColorProvider>().greyColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      for (int i = 0; i < 7; i++)
                                        SelectableDayInTheWeek(
                                            selectedDaysAWeek:
                                                selectedDaysAWeek,
                                            index: i),
                                    ]),
                              )
                            ],
                          )
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  if (Platform.isIOS) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(actions: [
              for (var option in options)
                CupertinoActionSheetAction(
                  child: Text(
                    option,
                    style: const TextStyle(fontFamily: "Poppins"),
                  ),
                  onPressed: () {
                    context.read<DataProvider>().updateHabitType(option);
                    if (isEdit) {
                      context.read<HabitProvider>().updateSomethingEdited();
                    }
                    Navigator.pop(context);
                    if (option != "Daily") {
                      showHabitTypeOptions(context, option);
                    }
                  },
                ),
            ]));
  } else {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context, listen: false).greyColor,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          for (var option in options)
            Column(
              children: [
                ListTile(
                  visualDensity: VisualDensity.compact,
                  enableFeedback: boolBox.get("hapticFeedback"),
                  textColor: AppColors.theLightColor,
                  titleTextStyle:
                      const TextStyle(fontSize: 16, fontFamily: "Poppins"),
                  title: Text(
                    option,
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    context.read<DataProvider>().updateHabitType(option);
                    if (isEdit) {
                      context.read<HabitProvider>().updateSomethingEdited();
                    }
                    Navigator.pop(context);
                    if (option != "Daily") {
                      showHabitTypeOptions(context, option);
                    }
                  },
                ),
                if (option != options.last)
                  const Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class SelectableDayInTheWeek extends StatefulWidget {
  const SelectableDayInTheWeek({
    super.key,
    required this.selectedDaysAWeek,
    required this.index,
  });

  final List<bool> selectedDaysAWeek;
  final int index;

  @override
  State<SelectableDayInTheWeek> createState() => _SelectableDayInTheWeekState();
}

class _SelectableDayInTheWeekState extends State<SelectableDayInTheWeek> {
  final List<String> dayNames = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  @override
  Widget build(BuildContext context) {
    int selectedDays = 0;
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () => setState(() {
              for (bool selectedDay in widget.selectedDaysAWeek) {
                if (selectedDay) {
                  selectedDays++;
                }
              }
              if (selectedDays != 6 || widget.selectedDaysAWeek[widget.index]) {
                widget.selectedDaysAWeek[widget.index] =
                    !widget.selectedDaysAWeek[widget.index];
              }
            }),
            child: Stack(
              children: [
                Positioned.fill(
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(
                          begin: 0,
                          end: widget.selectedDaysAWeek[widget.index] ? 1 : 0,
                        ),
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(15),
                            value: value,
                            color: AppColors.theOtherColor,
                            backgroundColor:
                                context.watch<ColorProvider>().greyColor,
                          );
                        }),
                  ),
                ),
                Center(
                    child: AutoSizeText(
                  dayNames[widget.index],
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
