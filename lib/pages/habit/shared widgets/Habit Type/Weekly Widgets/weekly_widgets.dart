import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Weekly%20Widgets/selectable_day_week.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class WeeklyWidgets extends StatefulWidget {
  const WeeklyWidgets({super.key});

  @override
  State<WeeklyWidgets> createState() => _WeeklyWidgetsState();
}

class _WeeklyWidgetsState extends State<WeeklyWidgets> {
  @override
  void initState() {
    super.initState();

    int selectedDays = 0;
    for (int i = 0;
        i <
            Provider.of<DataProvider>(context, listen: false)
                .selectedDaysAWeek
                .length;
        i++) {
      selectedDays++;
    }

    if (selectedDays == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DataProvider>().setShowMoreOptionsWeekly(false);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DataProvider>().setShowMoreOptionsWeekly(true);
        context.read<DataProvider>().setWeekValueSelected(selectedDays - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> values = [
      AppLocale.once.getString(context),
      AppLocale.twice.getString(context),
      "${AppLocale.three.getString(context)} ${AppLocale.days.getString(context)}",
      "${AppLocale.four.getString(context)} ${AppLocale.days.getString(context)}",
      "${AppLocale.five.getString(context)} ${AppLocale.days.getString(context)}",
      "${AppLocale.six.getString(context)} ${AppLocale.days.getString(context)}",
    ];
    bool showMoreOptionsWeekly =
        context.watch<DataProvider>().showMoreOptionsWeekly;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocale.weekly.getString(context),
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
                  context.read<DataProvider>().unselectAllDaysAWeek();
                  if (Provider.of<DataProvider>(context, listen: false)
                          .weekValueSelected >
                      5) {
                    context.read<DataProvider>().setWeekValueSelected(1);
                  } else {
                    context.read<DataProvider>().increaseWeekValueSelected();
                  }

                  print(Provider.of<DataProvider>(context, listen: false)
                      .weekValueSelected);
                },
                child: Text(
                  values[context.watch<DataProvider>().weekValueSelected - 1],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )),
            Text(
              " ${AppLocale.aWeek.getString(context)}.",
              style: const TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
        Visibility(
          visible:
              !context.watch<DataProvider>().selectedDaysAWeek.contains(true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                "${AppLocale.thisHabitWillAppear.getString(context)} ${values[context.watch<DataProvider>().weekValueSelected - 1].toLowerCase()} ${AppLocale.aWeek.getString(context)} ${AppLocale.untilCompleted.getString(context)}${context.watch<DataProvider>().weekValueSelected == 1 ? "." : " ${context.watch<DataProvider>().weekValueSelected} ${AppLocale.times.getString(context)}."}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        ListTile(
            onTap: () => context
                .read<DataProvider>()
                .setShowMoreOptionsWeekly(!showMoreOptionsWeekly),
            splashColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              AppLocale.moreOptions.getString(context),
            ),
            trailing: Icon(
                showMoreOptionsWeekly ? Icons.expand_less : Icons.expand_more)),
        if (showMoreOptionsWeekly)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${AppLocale.selectDays.getString(context)}:"),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: context.watch<ColorProvider>().greyColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 1; i < 8; i++)
                        SelectableDayInTheWeek(
                          index: i,
                        ),
                    ]),
              ),
              const SizedBox(height: 10),
              Text(
                  "${AppLocale.leaveUnselectedWeek.getString(context)}${context.watch<DataProvider>().weekValueSelected == 1 ? "." : " ${context.watch<DataProvider>().weekValueSelected} ${AppLocale.times.getString(context)}."}",
                  style: const TextStyle(color: Colors.grey))
            ],
          )
      ],
    );
  }
}
