import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Monthly%20Widgets/selectable_day_month.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

class MonthlyWidgets extends StatefulWidget {
  const MonthlyWidgets({super.key});

  @override
  State<MonthlyWidgets> createState() => _MonthlyWidgetsState();
}

class _MonthlyWidgetsState extends State<MonthlyWidgets> {
  List<String> values = [
    "Once",
    "Twice",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
  ];

  String getMonthlyText() {
    String text = "";
    if (context.watch<DataProvider>().monthValueSelected < 2) {
      text = values[context.watch<DataProvider>().monthValueSelected];
    } else if (context.watch<DataProvider>().monthValueSelected < 9) {
      text = "${values[context.watch<DataProvider>().monthValueSelected]} days";
    } else {
      text = "${context.watch<DataProvider>().monthValueSelected + 1} days";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    bool showMoreOptionsMonthly =
        context.watch<DataProvider>().showMoreOptionsMonthly;
    return Column(
      children: [
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
                      28) {
                    context.read<DataProvider>().setMonthValueSelected(0);
                  } else {
                    context.read<DataProvider>().increaseMonthValueSelected();
                  }
                },
                child: Text(
                  getMonthlyText(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )),
            const Text(
              " a month.",
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "This habit will appear ${getMonthlyText().toLowerCase()} a month until completed${context.watch<DataProvider>().monthValueSelected == 0 ? "." : " ${context.watch<DataProvider>().monthValueSelected + 1} times."}",
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 15),
        ListTile(
            onTap: () => context
                .read<DataProvider>()
                .setShowMoreOptionsMonthly(!showMoreOptionsMonthly),
            splashColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            title: const Text("More options"),
            trailing: Icon(showMoreOptionsMonthly
                ? Icons.expand_less
                : Icons.expand_more)),
        if (showMoreOptionsMonthly)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select days for this habit:"),
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
                          for (int i = 0; i < 7; i++)
                            SelectableDayInTheMonth(
                              index: i,
                            ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 7; i < 14; i++)
                            SelectableDayInTheMonth(
                              index: i,
                            ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 14; i < 21; i++)
                            SelectableDayInTheMonth(
                              index: i,
                            ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 21; i < 28; i++)
                            SelectableDayInTheMonth(
                              index: i,
                            ),
                        ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      for (int i = 28; i < 31; i++)
                        SelectableDayInTheMonth(
                          index: i,
                        ),
                      for (int i = 31; i < 35; i++)
                        const Expanded(child: AspectRatio(aspectRatio: 1))
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                  "Leave unselected if you want the habit to appear every day until completed${context.watch<DataProvider>().monthValueSelected == 0 ? "" : " ${context.watch<DataProvider>().monthValueSelected + 1} times"} every month.",
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              const Text(
                  "Note: If a month doesn't have the selected day (31st, 30th, etc.) this habit, of course, won't appear that day.",
                  style: TextStyle(color: Colors.grey))
            ],
          )
      ],
    );
  }
}
