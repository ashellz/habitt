import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Monthly%20Widgets/selectable_day_month.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class MonthlyWidgets extends StatefulWidget {
  const MonthlyWidgets({super.key});

  @override
  State<MonthlyWidgets> createState() => _MonthlyWidgetsState();
}

class _MonthlyWidgetsState extends State<MonthlyWidgets> {
  List<String> values = [];

  String getMonthlyText() {
    String text = "";
    if (context.watch<DataProvider>().monthValueSelected < 3) {
      text = values[context.watch<DataProvider>().monthValueSelected - 1];
    } else if (context.watch<DataProvider>().monthValueSelected < 11) {
      text =
          "${values[context.watch<DataProvider>().monthValueSelected - 1]} ${AppLocale.days.getString(context)}";
    } else {
      text =
          "${context.watch<DataProvider>().monthValueSelected} ${AppLocale.days.getString(context)}";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    values = [
      AppLocale.once.getString(context),
      AppLocale.twice.getString(context),
      AppLocale.three.getString(context),
      AppLocale.four.getString(context),
      AppLocale.five.getString(context),
      AppLocale.six.getString(context),
      AppLocale.seven.getString(context),
      AppLocale.eight.getString(context),
      AppLocale.nine.getString(context),
      AppLocale.ten.getString(context)
    ];
    bool showMoreOptionsMonthly =
        context.watch<DataProvider>().showMoreOptionsMonthly;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocale.monthly.getString(context),
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.theLightColor)),
        const SizedBox(height: 15),
        Row(
          children: [
            TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        context.watch<ColorProvider>().greyColor)),
                onPressed: () {
                  context.read<DataProvider>().unselectAllDaysAMonth();
                  if (Provider.of<DataProvider>(context, listen: false)
                          .monthValueSelected >
                      29) {
                    context.read<DataProvider>().setMonthValueSelected(1);
                  } else {
                    context.read<DataProvider>().increaseMonthValueSelected();
                  }

                  print(Provider.of<DataProvider>(context, listen: false)
                      .monthValueSelected);
                },
                child: Text(
                  getMonthlyText(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )),
            Text(
              " ${AppLocale.aMonth.getString(context)}.",
              style: const TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
        Visibility(
            visible: context.watch<DataProvider>().selectedDaysAMonth.isEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  "${AppLocale.thisHabitWillAppear.getString(context)} ${getMonthlyText().toLowerCase()} ${AppLocale.aMonth.getString(context)} ${AppLocale.untilCompleted.getString(context)}${context.watch<DataProvider>().monthValueSelected == 1 ? "." : " ${context.watch<DataProvider>().monthValueSelected} ${AppLocale.times.getString(context)}."}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 15),
              ],
            )),
        ListTile(
            onTap: () => context
                .read<DataProvider>()
                .setShowMoreOptionsMonthly(!showMoreOptionsMonthly),
            splashColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            title: Text(AppLocale.moreOptions.getString(context)),
            trailing: Icon(showMoreOptionsMonthly
                ? Icons.expand_less
                : Icons.expand_more)),
        if (showMoreOptionsMonthly)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppLocale.selectDays.getString(context)}:",
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 265.4,
                decoration: BoxDecoration(
                  color: context.watch<ColorProvider>().greyColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 1; i < 8; i++)
                            SelectableDayInTheMonth(
                              index: i,
                            ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 8; i < 15; i++)
                            SelectableDayInTheMonth(
                              index: i,
                            ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 15; i < 22; i++)
                            SelectableDayInTheMonth(
                              index: i,
                            ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 22; i < 29; i++)
                            SelectableDayInTheMonth(
                              index: i,
                            ),
                        ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      for (int i = 29; i < 32; i++)
                        SelectableDayInTheMonth(
                          index: i,
                        ),
                      for (int i = 32; i < 36; i++)
                        const Expanded(child: AspectRatio(aspectRatio: 1))
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                  "${AppLocale.leaveUnselectedMonth.getString(context)} ${context.watch<DataProvider>().monthValueSelected == 1 ? "" : " ${context.watch<DataProvider>().monthValueSelected} ${AppLocale.times.getString(context)}."}",
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Text(AppLocale.noteMonth.getString(context),
                  style: const TextStyle(color: Colors.grey))
            ],
          )
      ],
    );
  }
}
