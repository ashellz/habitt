import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/historical_habit.dart';

import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/objects/habit/calendar_habit_tile.dart';

class AdditionalHistoricalTasks extends StatefulWidget {
  const AdditionalHistoricalTasks(
      {super.key,
      required this.isAdLoaded,
      required this.interstitialAd,
      required this.today});

  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;
  final DateTime today;

  @override
  State<AdditionalHistoricalTasks> createState() =>
      _AdditionalHistoricalTasksState();
}

class _AdditionalHistoricalTasksState extends State<AdditionalHistoricalTasks> {
  @override
  Widget build(BuildContext context) {
    bool hasTasks = false;
    bool todayExists = false;

    int habitListLength = 0;
    int boxIndex = 0;
    List<HistoricalHabitData> habitsOnDate = [];
    DateTime today = widget.today;
    List<int> todayDate = [today.year, today.month, today.day];

    for (int i = 0; i < historicalBox.length; i++) {
      List<int> date = [
        historicalBox.getAt(i)!.date.year,
        historicalBox.getAt(i)!.date.month,
        historicalBox.getAt(i)!.date.day
      ];

      if (const ListEquality().equals(date, todayDate)) {
        todayExists = true;
        boxIndex = i;
        habitListLength = historicalBox.getAt(i)!.data.length;
        habitsOnDate = historicalBox.getAt(i)!.data;
        break;
      }
    }

    for (var habit in habitsOnDate) {
      if (habit.task == true) {
        hasTasks = true;
        break;
      }
      hasTasks = false;
    }

    if (!hasTasks || !todayExists) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            const TasksDivider(),
            for (int i = 0; i < habitListLength && i < habitsOnDate.length; i++)
              if (habitsOnDate[i].task == true)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CalendarHabitTile(
                    boxIndex: boxIndex,
                    time: widget.today,
                    habits: habitsOnDate,
                    index: i,
                    isAdLoaded: widget.isAdLoaded,
                    interstitialAd: widget.interstitialAd,
                  ),
                )
          ],
        ),
      );
    }
  }
}

class TasksDivider extends StatelessWidget {
  const TasksDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 30, left: 40, right: 40),
      child: Row(
        children: <Widget>[
          // Left Divider
          Expanded(
            child: Divider(
              color: Colors.grey, // Customize color
              thickness: 1, // Customize thickness
            ),
          ),
          // The Text in the middle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Additional tasks", // Customize the text
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ), // Customize text style
            ),
          ),
          // Right Divider
          Expanded(
            child: Divider(
              color: Colors.grey, // Customize color
              thickness: 1, // Customize thickness
            ),
          ),
        ],
      ),
    );
  }
}
