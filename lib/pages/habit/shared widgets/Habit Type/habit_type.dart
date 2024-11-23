import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/habit_type_options.dart';
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
  List<String> options = [
    AppLocale.daily.getString(context),
    AppLocale.weekly.getString(context),
    AppLocale.monthly.getString(context),
    AppLocale.custom.getString(context)
  ];

  if (Platform.isIOS) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(actions: [
              for (var option in options)
                CupertinoActionSheetAction(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const SizedBox(),
                        Text(
                          option,
                          style: const TextStyle(fontFamily: "Poppins"),
                        ),
                        Icon(
                          option ==
                                  context
                                      .watch<DataProvider>()
                                      .habitTypeController
                                      .text
                              ? Icons.check
                              : null,
                          color: AppColors.theLightColor,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    context.read<DataProvider>().updateHabitType(option);
                    if (isEdit) {
                      context.read<HabitProvider>().updateSomethingEdited();
                    }
                    Navigator.pop(context);

                    print("Option here: !!!!! " + option);
                    if (option != AppLocale.daily.getString(context)) {
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
                if (option == options.first) const SizedBox(height: 6),
                ListTile(
                  visualDensity: VisualDensity.compact,
                  enableFeedback: boolBox.get("hapticFeedback"),
                  textColor: AppColors.theLightColor,
                  titleTextStyle:
                      const TextStyle(fontSize: 16, fontFamily: "Poppins"),
                  leading: const SizedBox(
                    width: 30,
                  ),
                  title: Text(
                    option,
                    textAlign: TextAlign.center,
                  ),
                  trailing: Icon(
                    option ==
                            context
                                .watch<DataProvider>()
                                .habitTypeController
                                .text
                        ? Icons.check
                        : null,
                    color: AppColors.theLightColor,
                  ),
                  onTap: () {
                    context.read<DataProvider>().updateHabitType(option);
                    if (isEdit) {
                      context.read<HabitProvider>().updateSomethingEdited();
                    }
                    Navigator.pop(context);
                    if (option != AppLocale.daily.getString(context)) {
                      showHabitTypeOptions(context, option);
                    }
                  },
                ),
                if (option == options.last) const SizedBox(height: 6),
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
