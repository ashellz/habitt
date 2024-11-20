import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

class CupertinoCompleteHistoricalHabitWidget extends StatelessWidget {
  const CupertinoCompleteHistoricalHabitWidget(
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

    double getHourMax() {
      double hourMax = 0;

      if (habit.duration % 60 > 0) {
        hourMax = (habit.duration ~/ 60).toDouble();
      } else {
        hourMax = (habit.duration ~/ 60) - 1;
      }

      return hourMax;
    }

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (amountCheck)
            Column(
              children: [
                SpinBox(
                  cursorColor: Colors.white,
                  iconColor: WidgetStateProperty.all<Color>(Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    ),
                    filled: false,
                  ),
                  min: 0,
                  max: habit.amount - 1,
                  value: theAmountValue.toDouble(),
                  onChanged: (value) {
                    if (boolBox.get("hapticFeedback")!) {
                      HapticFeedback.lightImpact();
                    }
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade800),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade800),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      filled: false,
                      labelStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white38,
                          fontWeight: FontWeight.bold),
                      labelText:
                          AppLocale.hours.getString(context).toUpperCase(),
                    ),
                    min: 0,
                    max: getHourMax(),
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

                        if (updatedDurationValueHours ==
                            (habit.duration ~/ 60)) {
                          if (theDurationValueMinutes >
                              (habit.duration % 60 - 1)) {
                            context
                                .read<DataProvider>()
                                .setDurationValueMinutes(
                                    (habit.duration % 60) - 1);
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    ),
                    filled: false,
                    labelStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white38,
                        fontWeight: FontWeight.bold),
                    labelText:
                        AppLocale.minutes.getString(context).toUpperCase(),
                  ),
                  min: 0,
                  max: theDurationValueHours.toDouble() < habit.duration ~/ 60
                      ? 59
                      : habit.duration % 60 - 1,
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
      ),
    );
  }
}
