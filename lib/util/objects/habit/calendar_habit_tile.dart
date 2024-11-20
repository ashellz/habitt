import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/objects/habit/Complete%20Historical%20Habit%20Dialog/complete_historical_habit_dialog.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CalendarHabitTile extends StatefulWidget {
  const CalendarHabitTile({
    super.key,
    required this.index,
    required this.habits,
    required this.time,
    required this.boxIndex,
    required this.isAdLoaded,
    required this.interstitialAd,
  });
  final int index;
  final List<HistoricalHabitData> habits;
  final DateTime time;
  final int boxIndex;

  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;

  @override
  State<CalendarHabitTile> createState() => _CalendarHabitTileState();
}

class _CalendarHabitTileState extends State<CalendarHabitTile> {
  @override
  Widget build(BuildContext context) {
    List<int> chosenDate = [
      widget.time.year,
      widget.time.month,
      widget.time.day
    ];
    List<int> realDate = [
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day
    ];

    bool isToday = const ListEquality().equals(chosenDate, realDate);

    int index = widget.index;
    List<HistoricalHabitData> habits = widget.habits;

    bool amountCheck = false;
    bool durationCheck = false;

    if (habits[index].amount > 1) {
      amountCheck = true;
    } else if (habits[index].duration > 0) {
      durationCheck = true;
    }

    var habit = context
        .watch<HistoricalHabitProvider>()
        .allHistoricalHabits[widget.boxIndex]
        .data[index];

    return Slidable(
      enabled: habit.completed ? habit.skipped : true,
      closeOnScroll: true,
      startActionPane: ActionPane(
        dragDismissible: true,
        extentRatio: 0.35,
        motion: const ScrollMotion(),
        children: [
          const SizedBox(
            width: 10,
          ),
          SlidableAction(
            onPressed: (context) {
              context
                  .read<HistoricalHabitProvider>()
                  .skipHistoricalHabit(index, habit, widget.time, context);
              if (isToday) {
                context.read<HabitProvider>().skipHabitProvider(index);
              }
            },
            backgroundColor: context.watch<ColorProvider>().greyColor,
            foregroundColor: Colors.white,
            label: habit.skipped ? 'Undo' : 'Skip',
            borderRadius: BorderRadius.circular(15),
          ),
        ],
      ),
      child: HabitTile(
        index: index,
        widget: widget,
        amountCheck: amountCheck,
        durationCheck: durationCheck,
        habit: habit,
        isToday: isToday,
        interstitialAd: widget.interstitialAd,
        isAdLoaded: widget.isAdLoaded,
      ),
    );
  }
}

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.index,
    required this.widget,
    required this.amountCheck,
    required this.durationCheck,
    required this.habit,
    required this.isToday,
    required this.isAdLoaded,
    required this.interstitialAd,
  });

  final int index;
  final CalendarHabitTile widget;
  final bool amountCheck;
  final bool durationCheck;
  final HistoricalHabitData habit;
  final bool isToday;

  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;

  @override
  Widget build(BuildContext context) {
    DateTime time = widget.time;
    return ListTile(
      leading: Icon(
        getIcon(index),
        color: habit.completed ? Colors.grey.shade700 : Colors.white,
      ),
      title: Text(
        habit.name,
        overflow: TextOverflow.ellipsis,
        style: textStyleCompletedCheck(),
      ),
      trailing: CheckBox(
        amountCheck: amountCheck,
        durationCheck: durationCheck,
        index: index,
        habit: habit,
        time: time,
        isToday: isToday,
        interstitialAd: interstitialAd,
        isAdLoaded: isAdLoaded,
      ),
    );
  }

  TextStyle textStyleCompletedCheck() {
    return TextStyle(
        color: habit.completed ? Colors.grey.shade700 : Colors.white,
        decoration: habit.completed ? TextDecoration.lineThrough : null,
        decorationColor: Colors.grey.shade700,
        decorationThickness: 3.0);
  }
}

class CheckBox extends StatefulWidget {
  const CheckBox({
    super.key,
    required this.amountCheck,
    required this.durationCheck,
    required this.index,
    required this.habit,
    required this.time,
    required this.isToday,
    required this.isAdLoaded,
    required this.interstitialAd,
  });

  final bool amountCheck;
  final bool durationCheck;
  final int index;
  final HistoricalHabitData habit;
  final DateTime time;
  final bool isToday;
  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    var habit = widget.habit;
    DateTime time = widget.time;
    return GestureDetector(
      onTap: () {
        checkCompleteHabit(
            widget.amountCheck,
            widget.durationCheck,
            widget.index,
            context,
            habit,
            time,
            widget.isToday,
            widget.isAdLoaded,
            widget.interstitialAd);
      },
      child: Container(
          clipBehavior: Clip.hardEdge,
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: widget.habit.completed
                ? AppColors.theOtherColor
                : context.watch<ColorProvider>().greyColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: habit.completed && !habit.skipped
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(
                              begin: 0,
                              end: habit.completed ? 1 : 0,
                            ),
                            builder: (context, value, _) {
                              return LinearProgressIndicator(
                                value: value,
                                color: AppColors.theOtherColor,
                                backgroundColor:
                                    context.watch<ColorProvider>().greyColor,
                              );
                            }),
                      ),
                    ),
                    Center(
                      child: Icon(
                          widget.habit.completed ? Icons.check : Icons.close,
                          color: Colors.white),
                    ),
                  ],
                )
              : widget.amountCheck
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeInOut,
                                tween: Tween<double>(
                                  begin: 0,
                                  end: habit.amountCompleted / habit.amount,
                                ),
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    color: habit.skipped
                                        ? Colors.grey.shade800
                                        : AppColors.theOtherColor,
                                    backgroundColor: context
                                        .watch<ColorProvider>()
                                        .greyColor,
                                  );
                                }),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Transform.translate(
                                offset: const Offset(0, 3),
                                child: Text(
                                  habit.amountCompleted.toString(),
                                  style: TextStyle(
                                      color: habit.skipped
                                          ? Colors.grey
                                          : Colors.white,
                                      fontSize: 10),
                                ),
                              ),
                              Divider(
                                color:
                                    habit.skipped ? Colors.grey : Colors.white,
                                thickness: 1,
                                indent: 15,
                                endIndent: 15,
                              ),
                              Transform.translate(
                                offset: const Offset(0, -3),
                                child: Text(
                                  habit.amount.toString(),
                                  style: TextStyle(
                                      color: habit.skipped
                                          ? Colors.grey
                                          : Colors.white,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : widget.durationCheck
                      ? Stack(
                          children: [
                            Positioned.fill(
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: TweenAnimationBuilder<double>(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    curve: Curves.easeInOut,
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: habit.durationCompleted /
                                          habit.duration,
                                    ),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        color: habit.skipped
                                            ? Colors.grey.shade800
                                            : AppColors.theOtherColor,
                                        backgroundColor: context
                                            .watch<ColorProvider>()
                                            .greyColor,
                                      );
                                    }),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(0, 3),
                                    child: Text(
                                      habit.durationCompleted ~/ 60 == 0
                                          ? "${habit.durationCompleted % 60}m"
                                          : habit.durationCompleted % 60 == 0
                                              ? "${habit.durationCompleted ~/ 60}h"
                                              : "${habit.durationCompleted ~/ 60}h${habit.durationCompleted % 60}m",
                                      style: TextStyle(
                                          color: habit.skipped
                                              ? Colors.grey
                                              : Colors.white,
                                          fontSize: 10),
                                    ),
                                  ),
                                  Divider(
                                    color: habit.skipped
                                        ? Colors.grey
                                        : Colors.white,
                                    thickness: 1,
                                    indent: 15,
                                    endIndent: 15,
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -3),
                                    child: Text(
                                      habit.duration ~/ 60 == 0
                                          ? "${habit.duration % 60}m"
                                          : habit.duration % 60 == 0
                                              ? "${habit.duration ~/ 60}h"
                                              : "${habit.duration ~/ 60}h${habit.duration % 60}m",
                                      style: TextStyle(
                                          color: habit.skipped
                                              ? Colors.grey
                                              : Colors.white,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Positioned.fill(
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: TweenAnimationBuilder<double>(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    curve: Curves.easeInOut,
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: habit.completed ? 1 : 0,
                                    ),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        color: habit.skipped
                                            ? Colors.grey.shade800
                                            : AppColors.theOtherColor,
                                        backgroundColor: context
                                            .watch<ColorProvider>()
                                            .greyColor,
                                      );
                                    }),
                              ),
                            ),
                            Center(
                              child: Icon(
                                  widget.habit.completed
                                      ? Icons.check
                                      : Icons.close,
                                  color: Colors.white),
                            ),
                          ],
                        )),
    );
  }
}

void checkCompleteHabit(
    amountCheck,
    durationCheck,
    int index,
    BuildContext context,
    HistoricalHabitData habit,
    DateTime time,
    bool isToday,
    bool isAdLoaded,
    interstitialAd) {
  if (amountCheck == true || durationCheck == true) {
    if (habit.completed) {
      if (isToday) {
        context
            .read<HabitProvider>()
            .completeHabitProvider(index, isAdLoaded, interstitialAd);
        context
            .read<HistoricalHabitProvider>()
            .completeHistoricalHabit(index, habit, time, context);
      } else {
        context
            .read<HistoricalHabitProvider>()
            .completeHistoricalHabit(index, habit, time, context);
      }
    } else {
      completeHistoricalHabitDialog(index, context, time, isToday);
    }
  } else {
    if (isToday) {
      context
          .read<HabitProvider>()
          .completeHabitProvider(index, isAdLoaded, interstitialAd);
    }
    context
        .read<HistoricalHabitProvider>()
        .completeHistoricalHabit(index, habit, time, context);
  }
}
