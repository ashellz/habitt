import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/habit/edit_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:habit_tracker/util/objects/complete_habit.dart';
import 'package:hive/hive.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';

class NewHabitTile extends StatefulWidget {
  const NewHabitTile({
    super.key,
    required this.index,
    required this.editcontroller,
  });
  final int index;
  final TextEditingController editcontroller;

  @override
  State<NewHabitTile> createState() => _NewHabitTileState();
}

class _NewHabitTileState extends State<NewHabitTile> {
  final habitBox = Hive.box<HabitData>('habits');

  @override
  Widget build(BuildContext context) {
    bool amountCheck = false;
    bool durationCheck = false;

    if (habitBox.getAt(widget.index)!.amount > 1) {
      amountCheck = true;
    } else if (habitBox.getAt(widget.index)!.duration > 0) {
      durationCheck = true;
    }

    var editcontroller = widget.editcontroller;
    int index = widget.index;
    var habit = context.read<HabitProvider>().getHabitAt(index);
    return GestureDetector(
      onTap: () {
        habitGoalEdit = 0;
        updated = false;
        dropDownChanged = false;
        editcontroller.text = "";
        changed = false;
        updatedIcon = startIcon;
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => EditHabitPage(
                      index: index,
                      editcontroller: editcontroller,
                    )))
            .whenComplete(() {
          habitGoalEdit = 0;
          updated = false;
          dropDownChanged = false;
          editcontroller.clear();
          changed = false;
          updatedIcon = startIcon;
        });
      },
      child: Slidable(
        enabled: !habitBox.getAt(index)!.completed,
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
                context.read<HabitProvider>().skipHabitProvider(index);
              },
              backgroundColor: Colors.grey.shade900,
              foregroundColor: Colors.white,
              label: habitBox.getAt(index)!.skipped ? 'Undo' : 'Skip',
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: HabitTile(
            index: index,
            habitBox: habitBox,
            widget: widget,
            amountCheck: amountCheck,
            durationCheck: durationCheck,
            habit: habit),
      ),
    );
  }
}

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.index,
    required this.habitBox,
    required this.widget,
    required this.amountCheck,
    required this.durationCheck,
    required this.habit,
  });

  final int index;
  final Box<HabitData> habitBox;
  final NewHabitTile widget;
  final bool amountCheck;
  final bool durationCheck;
  final HabitData habit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        getIcon(index),
        color: habitBox.getAt(index)!.completed
            ? Colors.grey.shade700
            : Colors.white,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            truncatedText(context, habitBox.getAt(index)!.name),
            style: textStyleCompletedCheck(),
          ),
          StreakDisplay(habitBox: habitBox, index: index),
        ],
      ),
      trailing: CheckBox(
          amountCheck: amountCheck,
          durationCheck: durationCheck,
          habitBox: habitBox,
          index: index,
          habit: habit),
    );
  }

  TextStyle textStyleCompletedCheck() {
    return TextStyle(
        color: habitBox.getAt(index)!.completed
            ? Colors.grey.shade700
            : Colors.white,
        decoration: habitBox.getAt(widget.index)!.completed
            ? TextDecoration.lineThrough
            : null,
        decorationColor: Colors.grey.shade700,
        decorationThickness: 3.0);
  }
}

class StreakDisplay extends StatelessWidget {
  const StreakDisplay({
    super.key,
    required this.habitBox,
    required this.index,
  });

  final Box<HabitData> habitBox;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        MaterialCommunityIcons.fire,
        color: habitBox.getAt(index)!.completed ? Colors.white : Colors.grey,
        size: 21,
      ),
      Transform.translate(
        offset: const Offset(0, 1),
        child: Text(
          "${habitBox.getAt(index)!.completed ? habitBox.getAt(index)!.streak + 1 : habitBox.getAt(index)!.streak}",
          style: TextStyle(
              color:
                  habitBox.getAt(index)!.completed ? Colors.white : Colors.grey,
              fontSize: 14),
        ),
      )
    ]);
  }
}

class CheckBox extends StatefulWidget {
  const CheckBox({
    super.key,
    required this.amountCheck,
    required this.durationCheck,
    required this.habitBox,
    required this.index,
    required this.habit,
  });

  final bool amountCheck;
  final bool durationCheck;
  final Box<HabitData> habitBox;
  final int index;
  final HabitData habit;

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        checkCompleteHabit(widget.amountCheck, widget.durationCheck, widget.index, context);
      },
      child: Container(
          clipBehavior: Clip.hardEdge,
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: widget.habit.completed ? theOtherGreen : Colors.grey.shade900,
            borderRadius: BorderRadius.circular(15),
          ),
          child: widget.habitBox.getAt(widget.index)!.completed
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
                              end: widget.habitBox.getAt(widget.index)!.completed ? 1 : 0,
                            ),
                            builder: (context, value, _) {
                              return LinearProgressIndicator(
                                value: value,
                                color: widget.habitBox.getAt(widget.index)!.skipped
                                    ? Colors.grey.shade800
                                    : theOtherGreen,
                                backgroundColor: Colors.grey.shade900,
                              );
                            }),
                      ),
                    ),
                    Center(
                      child: Icon(widget.habit.completed ? Icons.check : Icons.close,
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
                                  end: widget.habitBox.getAt(widget.index)!.amountCompleted /
                                      widget.habitBox.getAt(widget.index)!.amount,
                                ),
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    color: widget.habitBox.getAt(widget.index)!.skipped
                                        ? Colors.grey.shade800
                                        : theOtherGreen,
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
                                  widget.habitBox
                                      .getAt(widget.index)!
                                      .amountCompleted
                                      .toString(),
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
                                  widget.habitBox.getAt(widget.index)!.amount.toString(),
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
                                      end: widget.habitBox
                                              .getAt(widget.index)!
                                              .durationCompleted /
                                          widget.habitBox.getAt(widget.index)!.duration,
                                    ),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        color: theOtherGreen,
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
                                      widget.habitBox
                                                      .getAt(widget.index)!
                                                      .durationCompleted ~/
                                                  60 ==
                                              0
                                          ? "${widget.habitBox.getAt(widget.index)!.durationCompleted % 60}m"
                                          : widget.habitBox
                                                          .getAt(widget.index)!
                                                          .durationCompleted %
                                                      60 ==
                                                  0
                                              ? "${widget.habitBox.getAt(widget.index)!.durationCompleted ~/ 60}h"
                                              : "${widget.habitBox.getAt(widget.index)!.durationCompleted ~/ 60}h${widget.habitBox.getAt(widget.index)!.durationCompleted % 60}m",
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
                                      "${widget.habitBox.getAt(widget.index)!.duration ~/ 60}h${widget.habitBox.getAt(widget.index)!.duration % 60}m",
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
                                      end: widget.habitBox.getAt(widget.index)!.completed
                                          ? 1
                                          : 0,
                                    ),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        color: theOtherGreen,
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
                        )),
    );
  }
}

void checkCompleteHabit(amountCheck, durationCheck, int index, BuildContext context) {
  if (amountCheck == true || durationCheck == true) {
    if (habitBox.getAt(index)!.completed) {
      context.read<HabitProvider>().completeHabitProvider(index);
    } else {
      showDialog(
          context: context, builder: (context) => completeHabitDialog(index));
    }
  } else {
    context.read<HabitProvider>().completeHabitProvider(index);
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
