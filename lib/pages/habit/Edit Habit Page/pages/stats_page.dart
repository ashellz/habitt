import 'package:animated_digit/animated_digit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/functions/buildCompletionRateGraph.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/pages/widgets/box.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/pages/widgets/get_completion_rate_days.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

Widget statsPage(
    BuildContext context,
    int id,
    bool isAdLoaded,
    interstitialAd,
    double? lowestCompletionRate,
    List<double> completionRates,
    double? highestCompletionRate,
    List<int> everyFifthDay,
    List<int> everyFifthMonth) {
  var habit = context.read<HabitProvider>().getHabitAt(id);

  int timesCompleted = 0;
  int timesMissed = 0;
  int timesSkipped = 0;
  int total = timesCompleted + timesMissed + timesSkipped;

  for (int i = 0; i < historicalBox.length; i++) {
    for (var historicalHabit in historicalBox.getAt(i)!.data) {
      if (historicalHabit.id == id) {
        if (historicalHabit.completed) {
          if (historicalHabit.skipped) {
            timesSkipped++;
          } else {
            timesCompleted++;
          }
        } else {
          timesMissed++;
        }
      }
    }
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

  // Widgets start here
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
                .completeHabitProvider(
                    context.read<HabitProvider>().getIndexFromId(id),
                    isAdLoaded,
                    interstitialAd)
                .then((value) {
              buildCompletionRateGraph(
                  id,
                  completionRates,
                  highestCompletionRate,
                  lowestCompletionRate,
                  everyFifthDay,
                  everyFifthMonth);
            });
          },
          child: Text(
            habitCompleted(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
      ),

      // streak
      StreakStats(habit: habit),

      //listveiw
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.5 - 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            box(text: "Times completed", value: timesCompleted, perc: false),
            const SizedBox(width: 10),
            box(text: "Times skipped", value: timesSkipped, perc: false),
            const SizedBox(width: 10),
            box(
                text: "Times missed",
                value: timesMissed == 1
                    ? total == 1
                        ? 0
                        : 1
                    : timesMissed,
                perc: false)
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),

      Container(
          padding: const EdgeInsets.all(20),
          height: 210,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.grey.shade900,
          ),
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Completion rate",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.start,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 120,
                child: LineChart(
                  duration: const Duration(milliseconds: 800),
                  LineChartData(
                      minY: 0,
                      maxY: 100,
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
                        verticalInterval: 5,
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
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            interval: 5,
                            getTitlesWidget: (value, meta) =>
                                GetCompletionRateDays(
                                    everyFifthDay: everyFifthDay,
                                    everyFifthMonth: everyFifthMonth,
                                    value: value),
                          )),
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
                ),
              ),
            ],
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
                  loop: false,
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
                    loop: false,
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
