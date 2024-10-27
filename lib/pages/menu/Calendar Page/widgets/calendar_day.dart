import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/colors.dart';

class CalendarDay extends StatelessWidget {
  const CalendarDay({super.key, required this.date, required this.selected});

  final DateTime date;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    List todayHabits(selectedDay) {
      List<int> habitsOnDate = [];
      late int habitsCompleted = 0;
      late int habitsTotal = 1;

      List day = [selectedDay.year, selectedDay.month, selectedDay.day];

      for (int i = 0; i < historicalBox.length; i++) {
        List habitDay = [
          historicalBox.getAt(i)!.date.year,
          historicalBox.getAt(i)!.date.month,
          historicalBox.getAt(i)!.date.day
        ];
        if (const ListEquality().equals(habitDay, day)) {
          habitsTotal = historicalBox.getAt(i)!.data.length;

          for (var habit in historicalBox.getAt(i)!.data) {
            if (habit.completed) {
              if (!habit.skipped) {
                habitsCompleted++;
              }
            }
          }

          break;
        }
      }

      habitsOnDate = [habitsCompleted, habitsTotal];

      if (habitsTotal == 0) {
        habitsOnDate = [0, 1];
      }

      return habitsOnDate;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: selected ? Colors.grey.shade800 : AppColors.theDarkGrey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: RotatedBox(
              quarterTurns: -1,
              child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(
                    begin: 0,
                    end: todayHabits(date)[0] / todayHabits(date)[1],
                  ),
                  builder: (context, value, _) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: value,
                        color: AppColors.theOtherColor,
                        backgroundColor: Colors.grey.shade900,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
