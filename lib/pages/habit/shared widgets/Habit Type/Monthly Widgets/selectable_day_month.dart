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
              for (int i = 0; i < selectedDaysAMonth.length; i++) {
                selectedDays++;
              }

              if (selectedDays < 31 ||
                  selectedDaysAMonth.contains(widget.index)) {
                if (selectedDaysAMonth.contains(widget.index)) {
                  selectedDaysAMonth.remove(widget.index);
                  selectedDays--;
                } else {
                  selectedDaysAMonth.add(widget.index);
                  selectedDays++;
                }
              }

              if (selectedDays == 0) {
                context.read<DataProvider>().setMonthValueSelected(1);
              } else {
                context
                    .read<DataProvider>()
                    .setMonthValueSelected(selectedDays);
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
                          end:
                              selectedDaysAMonth.contains(widget.index) ? 1 : 0,
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
                  "${widget.index}",
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
