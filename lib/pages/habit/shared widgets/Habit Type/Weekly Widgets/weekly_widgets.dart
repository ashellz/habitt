import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Weekly%20Widgets/selectable_day_week.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

class WeeklyWidgets extends StatefulWidget {
  const WeeklyWidgets({super.key});

  @override
  State<WeeklyWidgets> createState() => _WeeklyWidgetsState();
}

class _WeeklyWidgetsState extends State<WeeklyWidgets> {
  List<String> values = [
    "Once",
    "Twice",
    "Three days",
    "Four days",
    "Five days",
    "Six days"
  ];

  @override
  void initState() {
    super.initState();

    int selectedDays = 0;
    for (bool selectedDay in Provider.of<DataProvider>(context, listen: false)
        .selectedDaysAWeek) {
      if (selectedDay) {
        selectedDays++;
      }
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
    bool showMoreOptionsWeekly =
        context.watch<DataProvider>().showMoreOptionsWeekly;
    return Column(
      children: [
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
                      4) {
                    context.read<DataProvider>().setWeekValueSelected(0);
                  } else {
                    context.read<DataProvider>().increaseWeekValueSelected();
                  }
                },
                child: Text(
                  values[context.watch<DataProvider>().weekValueSelected],
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )),
            const Text(
              " a week.",
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "This habit will appear ${values[context.watch<DataProvider>().weekValueSelected].toLowerCase()} a week until completed${context.watch<DataProvider>().weekValueSelected == 0 ? "." : " ${context.watch<DataProvider>().weekValueSelected + 1} times."}",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 15),
        ListTile(
            onTap: () => context
                .read<DataProvider>()
                .setShowMoreOptionsWeekly(!showMoreOptionsWeekly),
            splashColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            title: const Text("More options"),
            trailing: Icon(
                showMoreOptionsWeekly ? Icons.expand_less : Icons.expand_more)),
        if (showMoreOptionsWeekly)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select days for this habit:"),
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
                      for (int i = 0; i < 7; i++)
                        SelectableDayInTheWeek(
                          index: i,
                        ),
                    ]),
              ),
              const SizedBox(height: 10),
              Text(
                  "Leave unselected if you want the habit to appear every day until completed${context.watch<DataProvider>().weekValueSelected == 0 ? "" : " ${context.watch<DataProvider>().weekValueSelected + 1} times"} every week.",
                  style: const TextStyle(color: Colors.grey))
            ],
          )
      ],
    );
  }
}
