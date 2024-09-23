import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_data.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:provider/provider.dart';

Widget statsPage(
    BuildContext context, int index, bool isAdLoaded, interstitialAd) {
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
            Text(
              perc ? "${value.toString()}%" : value.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: theLightColor),
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
      Row(
        children: [
          box("Completion rate", (timesCompleted / total * 100).toInt(), true),
          const Spacer(),
        ],
      ),
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

  String displayBestStreak() {
    late String bestStreak;

    if (habit.streak == habit.longestStreak) {
      if (habit.completed) {
        bestStreak = (habit.streak + 1).toString();
      } else {
        bestStreak = habit.streak.toString();
      }
    } else {
      bestStreak = habit.longestStreak.toString();
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
                Text(
                  "${habit.skipped ? habit.streak : habit.completed ? habit.streak + 1 : habit.streak}",
                  style: TextStyle(
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
                Text(displayBestStreak(),
                    style: TextStyle(
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
