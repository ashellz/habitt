import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/data/historical_habit.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:habit_tracker/util/objects/habit/complete_historical_habit.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CalendarHabitTile extends StatefulWidget {
  const CalendarHabitTile(
      {super.key,
      required this.index,
      required this.habits,
      required this.time,
      required this.boxIndex});
  final int index;
  final List<HistoricalHabitData> habits;
  final DateTime time;
  final int boxIndex;

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
        .watch<HabitProvider>()
        .allHistoricalHabits[widget.boxIndex]
        .data[index];

    return Slidable(
      enabled: !habit.completed,
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
                  .read<HabitProvider>()
                  .skipHistoricalHabit(index, habit, widget.time);
              if (isToday) {
                context.read<HabitProvider>().skipHabitProvider(index);
              }
            },
            backgroundColor: Colors.grey.shade900,
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
          isToday: isToday),
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
  });

  final int index;
  final CalendarHabitTile widget;
  final bool amountCheck;
  final bool durationCheck;
  final HistoricalHabitData habit;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    DateTime time = widget.time;
    return ListTile(
      leading: Icon(
        getIcon(index),
        color: habit.completed ? Colors.grey.shade700 : Colors.white,
      ),
      title: Text(
        truncatedText(context, habit.name),
        style: textStyleCompletedCheck(),
      ),
      trailing: CheckBox(
        amountCheck: amountCheck,
        durationCheck: durationCheck,
        index: index,
        habit: habit,
        time: time,
        isToday: isToday,
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
  });

  final bool amountCheck;
  final bool durationCheck;
  final int index;
  final HistoricalHabitData habit;
  final DateTime time;
  final bool isToday;

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
        checkCompleteHabit(widget.amountCheck, widget.durationCheck,
            widget.index, context, habit, time, widget.isToday);
      },
      child: Container(
          clipBehavior: Clip.hardEdge,
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color:
                widget.habit.completed ? theOtherColor : Colors.grey.shade900,
            borderRadius: BorderRadius.circular(15),
          ),
          child: habit.completed
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
                                color: habit.skipped
                                    ? Colors.grey.shade800
                                    : theOtherColor,
                                backgroundColor: Colors.grey.shade900,
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
                                        : theOtherColor,
                                    backgroundColor: Colors.grey.shade900,
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
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                              const Divider(
                                color: Colors.white,
                                thickness: 1,
                                indent: 15,
                                endIndent: 15,
                              ),
                              Transform.translate(
                                offset: const Offset(0, -3),
                                child: Text(
                                  habit.amount.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
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
                                        color: theOtherColor,
                                        backgroundColor: Colors.grey.shade900,
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
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.white,
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
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
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
                                        color: theOtherColor,
                                        backgroundColor: Colors.grey.shade900,
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
    bool isToday) {
  if (amountCheck == true || durationCheck == true) {
    if (habit.completed) {
      if (isToday) {
        context.read<HabitProvider>().completeHabitProvider(index);
      } else {
        context
            .read<HabitProvider>()
            .completeHistoricalHabit(index, habit, time);
        context.read<HabitProvider>().updateHistoricalHabits(time);
      }
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              completeHistoricalHabitDialog(index, context, time, isToday));
    }
  } else {
    if (isToday) {
      context.read<HabitProvider>().completeHabitProvider(index);
    } else {
      context.read<HabitProvider>().completeHistoricalHabit(index, habit, time);
    }
  }
}

String truncatedText(BuildContext context, String text) {
  double screenWidth = MediaQuery.of(context).size.width;
  int maxLength;

  if (screenWidth < 270) {
    maxLength = 6; // very very small screen
  } else if (screenWidth < 320) {
    maxLength = 10; // very small screen
  } else if (screenWidth < 370) {
    maxLength = 12; // small screen
  } else if (screenWidth < 400) {
    maxLength = 14; // small screen
  } else if (screenWidth < 450) {
    maxLength = 16; // medium screen
  } else if (screenWidth < 500) {
    maxLength = 18; // larger medium screen
  } else if (screenWidth < 550) {
    maxLength = 20; // large screen
  } else if (screenWidth < 600) {
    maxLength = 24; // larger screen
  } else if (screenWidth < 700) {
    maxLength = 30; // very large screen
  } else {
    maxLength = 35; // very very large screen
  }

  String name = text;
  if (name.length > maxLength) {
    return '${name.substring(0, maxLength)}...';
  }
  return name;
}
