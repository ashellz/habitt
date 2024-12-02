import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

class AndroidCompleteHistoricalHabitWidget extends StatelessWidget {
  const AndroidCompleteHistoricalHabitWidget(
      {super.key, required this.habit, required this.amountCheck});

  final bool amountCheck;
  final HistoricalHabitData habit;

  @override
  Widget build(BuildContext context) {
    int theAmountValue = context.watch<DataProvider>().theAmountValue;
    int theDurationValueHours =
        context.watch<DataProvider>().theDurationValueHours;
    int theDurationValueMinutes =
        context.watch<DataProvider>().theDurationValueMinutes;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (amountCheck)
          Column(
            children: [
              SpinBox(
                cursorColor: Colors.white,
                iconColor: WidgetStateProperty.all<Color>(Colors.white),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  filled: true,
                  fillColor: context.watch<ColorProvider>().greyColor,
                ),
                min: 0,
                max: habit.amount.toDouble(),
                value: theAmountValue.toDouble(),
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  context.read<DataProvider>().setAmountValue(value.toInt());
                },
              ),
              const SizedBox(height: 5),
              Text(habit.amountName)
            ],
          ),
        if (!amountCheck)
          Column(
            children: [
              if (habit.duration > 60)
                SpinBox(
                  cursorColor: Colors.white,
                  iconColor: WidgetStateProperty.all<Color>(Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    filled: true,
                    fillColor: context.watch<ColorProvider>().greyColor,
                    labelStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white38,
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: AppLocale.hours.getString(context),
                  ),
                  min: 0,
                  max: (habit.duration ~/ 60).toDouble(),
                  value: theDurationValueHours.toDouble(),
                  onChanged: (value) {
                    if (boolBox.get("hapticFeedback")!) {
                      HapticFeedback.lightImpact();
                    }

                    context
                        .read<DataProvider>()
                        .setDurationValueHours(value.toInt());

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final updatedDurationValueHours =
                          context.read<DataProvider>().theDurationValueHours;

                      if (updatedDurationValueHours == (habit.duration ~/ 60)) {
                        if (theDurationValueMinutes > (habit.duration % 60)) {
                          context
                              .read<DataProvider>()
                              .setDurationValueMinutes((habit.duration % 60));
                        }
                      }
                    });
                  },
                ),
              const SizedBox(height: 10),
              SpinBox(
                cursorColor: Colors.white,
                iconColor: WidgetStateProperty.all<Color>(Colors.white),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  filled: true,
                  fillColor: context.watch<ColorProvider>().greyColor,
                  labelStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: AppLocale.minutes.getString(context),
                ),
                min: 0,
                max: theDurationValueHours.toDouble() < habit.duration ~/ 60
                    ? 59
                    : habit.duration % 60,
                value: theDurationValueMinutes.toDouble(),
                onChanged: (value) {
                  if (boolBox.get("hapticFeedback")!) {
                    HapticFeedback.lightImpact();
                  }

                  context
                      .read<DataProvider>()
                      .setDurationValueMinutes(value.toInt());
                },
              ),
            ],
          ),
      ],
    );
  }
}
