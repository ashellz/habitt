import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

class AndroidCompleteHabitWidget extends StatelessWidget {
  const AndroidCompleteHabitWidget(
      {super.key, required this.index, required this.amountCheck});

  final int index;
  final bool amountCheck;

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
        Column(
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
                    max: habitBox.getAt(index)!.amount.toDouble(),
                    value: theAmountValue.toDouble(),
                    onChanged: (value) {
                      if (boolBox.get('hapticFeedback')!) {
                        HapticFeedback.lightImpact();
                      }
                      context
                          .read<DataProvider>()
                          .setAmountValue(value.toInt());
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
                            fontWeight: FontWeight.bold),
                        labelText: AppLocale.hours.getString(context),
                      ),
                      min: 0,
                      max: (habitBox.getAt(index)!.duration ~/ 60).toDouble(),
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
                          final updatedDurationValueHours = context
                              .read<DataProvider>()
                              .theDurationValueHours;

                          if (updatedDurationValueHours ==
                              (habitBox.getAt(index)!.duration ~/ 60)) {
                            if (theDurationValueMinutes >
                                (habitBox.getAt(index)!.duration % 60)) {
                              context
                                  .read<DataProvider>()
                                  .setDurationValueMinutes(
                                      (habitBox.getAt(index)!.duration % 60));
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
                          fontWeight: FontWeight.bold),
                      labelText: AppLocale.minutes.getString(context),
                    ),
                    min: 0,
                    max: theDurationValueHours.toDouble() <
                            habitBox.getAt(index)!.duration ~/ 60
                        ? 59
                        : habitBox.getAt(index)!.duration % 60,
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
        )
      ],
    );
  }
}
