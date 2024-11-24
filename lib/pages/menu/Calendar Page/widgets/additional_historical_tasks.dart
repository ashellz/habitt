import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:habitt/util/objects/habit/calendar_habit_tile.dart';
import 'package:provider/provider.dart';

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
    bool todayExists =
        context.watch<HistoricalHabitProvider>().historicalHabits.isNotEmpty;

    int habitListLength =
        context.watch<HistoricalHabitProvider>().historicalHabits.length;
    List<HistoricalHabitData> habitsOnDate =
        context.watch<HistoricalHabitProvider>().historicalHabits;

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
                    time: widget.today,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
      child: Row(
        children: <Widget>[
          // Left Divider
          const Expanded(
            child: Divider(
              color: Colors.grey, // Customize color
              thickness: 1, // Customize thickness
            ),
          ),
          // The Text in the middle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              AppLocale.additionalTasks
                  .getString(context), // Customize the text
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ), // Customize text style
            ),
          ),
          // Right Divider
          const Expanded(
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
