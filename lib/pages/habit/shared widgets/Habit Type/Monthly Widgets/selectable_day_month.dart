import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class SelectableDayInTheMonth extends StatefulWidget {
  const SelectableDayInTheMonth({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<SelectableDayInTheMonth> createState() =>
      _SelectableDayInTheMonthState();
}

class _SelectableDayInTheMonthState extends State<SelectableDayInTheMonth> {
  @override
  Widget build(BuildContext context) {
    final selectedDaysAMonth = context.watch<DataProvider>().selectedDaysAMonth;
    int selectedDays = 0;
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () => setState(() {
              for (bool selectedDay in selectedDaysAMonth) {
                if (selectedDay) {
                  selectedDays++;
                }
              }

              if (selectedDays < 30 || selectedDaysAMonth[widget.index]) {
                selectedDaysAMonth[widget.index] =
                    !selectedDaysAMonth[widget.index];
              }

              selectedDays = 0;
              for (bool selectedDay in selectedDaysAMonth) {
                if (selectedDay) {
                  selectedDays++;
                }
              }

              if (selectedDays == 0) {
                context
                    .read<DataProvider>()
                    .setMonthValueSelected(selectedDays);
              } else {
                context
                    .read<DataProvider>()
                    .setMonthValueSelected(selectedDays - 1);
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
                          end: selectedDaysAMonth[widget.index] ? 1 : 0,
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
                  "${widget.index + 1}",
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
