import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class SelectableDayInTheWeek extends StatefulWidget {
  const SelectableDayInTheWeek({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<SelectableDayInTheWeek> createState() => _SelectableDayInTheWeekState();
}

class _SelectableDayInTheWeekState extends State<SelectableDayInTheWeek> {
  List<String> dayNames = [];

  @override
  Widget build(BuildContext context) {
    final selectedDaysAWeek = context.watch<DataProvider>().selectedDaysAWeek;
    int selectedDays = 0;
    dayNames = [
      AppLocale.mon.getString(context),
      AppLocale.tue.getString(context),
      AppLocale.wed.getString(context),
      AppLocale.thu.getString(context),
      AppLocale.fri.getString(context),
      AppLocale.sat.getString(context),
      AppLocale.sun.getString(context),
    ];
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () => setState(() {
              for (int i = 0; i < selectedDaysAWeek.length; i++) {
                selectedDays++;
              }

              if (selectedDays < 6 ||
                  selectedDaysAWeek.contains(widget.index)) {
                if (selectedDaysAWeek.contains(widget.index)) {
                  selectedDaysAWeek.remove(widget.index);
                  selectedDays--;
                } else {
                  selectedDaysAWeek.add(widget.index);
                  selectedDays++;
                }
              }

              if (selectedDays == 0) {
                context.read<DataProvider>().setWeekValueSelected(selectedDays);
              } else {
                context
                    .read<DataProvider>()
                    .setWeekValueSelected(selectedDays - 1);
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
                          end: selectedDaysAWeek.contains(widget.index) ? 1 : 0,
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
