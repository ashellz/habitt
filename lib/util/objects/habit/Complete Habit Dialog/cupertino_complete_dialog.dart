import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

class CupertinoCompleteHabitWidget extends StatelessWidget {
  const CupertinoCompleteHabitWidget(
      {super.key, required this.index, required this.amountCheck});

  final bool amountCheck;
  final int index;

  double getHourMax() {
    double hourMax = 0;

    if (habitBox.getAt(index)!.duration % 60 > 0) {
      hourMax = (habitBox.getAt(index)!.duration ~/ 60).toDouble();
    } else {
      hourMax = (habitBox.getAt(index)!.duration ~/ 60) - 1;
    }

    return hourMax;
  }

  @override
  Widget build(BuildContext context) {
    int theAmountValue =
        Provider.of<DataProvider>(context, listen: false).theAmountValue;
    int theDurationValueHours =
        Provider.of<DataProvider>(context, listen: false).theDurationValueHours;
    int theDurationValueMinutes =
        Provider.of<DataProvider>(context, listen: false)
            .theDurationValueMinutes;

    return Material(
      color: Colors.transparent,
      child: Column(
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
                  max: habitBox.getAt(index)!.amount - 1,
                  value: theAmountValue.toDouble(),
                  onChanged: (value) {
                    if (boolBox.get('hapticFeedback')!) {
                      HapticFeedback.lightImpact();
                    }

                    context.read<DataProvider>().setAmountValue(value.toInt());
                  },
                ),
                const SizedBox(height: 5),
                Text(habitBox.getAt(index)!.amountName)
              ],
            ),
          if (!amountCheck)
            Column(
              children: [
                if (habitBox.getAt(index)!.duration > 60)
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
                      if (boolBox.get('hapticFeedback')!) {
                        HapticFeedback.lightImpact();
                      }

                      // Update the duration in the provider
                      context
                          .read<DataProvider>()
                          .setDurationValueHours(value.toInt());

                      // Use addPostFrameCallback to ensure the updated value is retrieved after the state change
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final updatedDurationValueHours =
                            context.read<DataProvider>().theDurationValueHours;

                        if (updatedDurationValueHours == getHourMax()) {
                          if (theDurationValueMinutes >
                              (habitBox.getAt(index)!.duration % 60 - 1)) {
                            context
                                .read<DataProvider>()
                                .setDurationValueMinutes(
                                    (habitBox.getAt(index)!.duration % 60) - 1);
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
                  max: theDurationValueHours.toDouble() <
                          habitBox.getAt(index)!.duration ~/ 60
                      ? 59
                      : habitBox.getAt(index)!.duration % 60 - 1,
                  value: theDurationValueMinutes.toDouble(),
                  onChanged: (value) {
                    if (boolBox.get('hapticFeedback')!) {
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
