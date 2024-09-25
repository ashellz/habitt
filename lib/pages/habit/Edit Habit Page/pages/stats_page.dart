import 'package:animated_digit/animated_digit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_data.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:provider/provider.dart';

Widget statsPage(
    BuildContext context,
    int index,
    bool isAdLoaded,
    interstitialAd,
    double? lowestCompletionRate,
    List<double> completionRates,
    double? highestCompletionRate) {
  var habit = habitBox.getAt(index)!;
  int timesCompleted = 0;
  int timesMissed = 0;
  int timesSkipped = 0;

  for (int i = 0; i < historicalBox.length; i++) {
    int dataLength = historicalBox.getAt(i)!.data.length;
    if (index < dataLength) {
      if (historicalBox.getAt(i)!.data[index].completed) {
        if (historicalBox.getAt(i)!.data[index].skipped) {
          timesSkipped++;
        } else {
          timesCompleted++;
        }
      } else {
        timesMissed++;
      }
    }
  }

  int total = timesCompleted + timesMissed + timesSkipped;

  Widget box(String text, var value, bool perc) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width * 0.5 - 30,
        height: MediaQuery.of(context).size.width * 0.5 - 30,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.grey.shade900),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              minFontSize: 12,
              text.split(" ")[0],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            AutoSizeText(
              minFontSize: 12,
              text.split(" ")[1],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                AnimatedDigitWidget(
                  duration: const Duration(milliseconds: 800),
                  value: value,
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: theLightColor),
                ),
                if (perc)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: theLightColor,
                        )),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String habitCompleted() {
    if (habit.completed) {
      if (habit.skipped) {
        return "Skipped";
      } else {
        return "Completed";
      }
    } else {
      return "Not Completed";
    }
  }

  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(children: [
      Center(
        child: TextButton(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all<Size>(
                Size(MediaQuery.of(context).size.width, 50)),
            backgroundColor: WidgetStateProperty.all<Color>(habit.skipped
                ? Colors.grey.shade900
                : habit.completed
                    ? theOtherColor
                    : Colors.grey.shade900),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          onPressed: () {
            Provider.of<HabitProvider>(context, listen: false)
                .completeHabitProvider(index, isAdLoaded, interstitialAd);
          },
          child: Text(
            habitCompleted(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      StreakStats(habit: habit),
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.5 - 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            box("Times completed", timesCompleted, false),
            box("Times skipped", timesSkipped, false),
            box(
                "Times missed",
                timesMissed == 1
                    ? total == 1
                        ? 0
                        : 1
                    : timesMissed,
                false)
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.width * 0.5 - 30,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.grey.shade900,
          ),
          child: LineChart(
            duration: const Duration(milliseconds: 800),
            LineChartData(
                minY: lowestCompletionRate,
                maxY: highestCompletionRate,
                minX: 1,
                maxX: completionRates.length.toDouble() + 1,
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                      spots: [
                        for (int i = 0; i < completionRates.length; i++)
                          FlSpot(
                              i + 1,
                              completionRates.reversed
                                  .toList()[i]
                                  .round()
                                  .toDouble())
                      ],
                      dotData: const FlDotData(
                        show: false,
                      ),
                      color: theOtherColor,
                      barWidth: 4,
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: theOtherColor.withOpacity(0.5),
                        gradient: LinearGradient(
                          colors: [
                            theOtherColor.withOpacity(0.5),
                            Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      )),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20,
                  verticalInterval: 30,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theAppBarColor,
                      strokeWidth: 0.5,
                      dashArray: [5, 5],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: theAppBarColor,
                      strokeWidth: 0.5,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 20,
                      getTitlesWidget: (value, meta) => Text(
                          "${value.toInt()}%",
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10)),
                    )))),
          ))
    ]),
  );
}

class StreakStats extends StatelessWidget {
  const StreakStats({
    super.key,
    required this.habit,
  });

  final HabitData habit;

  Color bestStreakColor() {
    Color color = Colors.white;

    if (habit.streak == habit.longestStreak) {
      color = theOtherColor;
    }

    return color;
  }

  int displayBestStreak() {
    late int bestStreak;

    if (habit.streak == habit.longestStreak) {
      if (habit.completed) {
        bestStreak = (habit.streak + 1);
      } else {
        bestStreak = habit.streak;
      }
    } else {
      bestStreak = habit.longestStreak;
    }

    return bestStreak;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                const AutoSizeText(
                  "Current streak",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 12,
                ),
                AnimatedDigitWidget(
                  duration: const Duration(milliseconds: 800),
                  value: habit.skipped
                      ? habit.streak
                      : habit.completed
                          ? habit.streak + 1
                          : habit.streak,
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: habit.skipped
                          ? Colors.white
                          : habit.completed
                              ? theOtherColor
                              : Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                const Text(
                  "Best streak",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                AnimatedDigitWidget(
                    duration: const Duration(milliseconds: 800),
                    value: displayBestStreak(),
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: bestStreakColor())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
