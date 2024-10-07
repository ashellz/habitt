import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/objects/habit/complete_habit_dialog.dart';
import 'package:hive/hive.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';

class NewHabitTile extends StatefulWidget {
  const NewHabitTile({
    super.key,
    required this.index,
    required this.editcontroller,
    required this.isAdLoaded,
    required this.interstitialAd,
  });
  final int index;
  final TextEditingController editcontroller;
  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;

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
        context.read<HabitProvider>().resetSomethingEdited();
        context.read<HabitProvider>().resetAppearenceEdited();
        Provider.of<HabitProvider>(context, listen: false).habitGoalValue = 0;
        updated = false;
        editcontroller.text = "";
        changed = false;
        Provider.of<HabitProvider>(context, listen: false).updatedIcon =
            startIcon;
        deleted = false;

        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => EditHabitPage(
                      index: index,
                      editcontroller: editcontroller,
                    )))
            .whenComplete(() {
          bool changeTag = true;
          for (int i = 0; i < tagBox.length; i++) {
            if (tagBox.getAt(i)!.tag == habitBox.getAt(index)!.tag) {
              changeTag = false;
              break;
            }
          }
          if (changeTag) {
            habitBox.getAt(index)!.tag = habitTag;
            changeTag = true;
          }
          if (context.mounted) {
            context.read<HabitProvider>().changeNotification([]);
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<HabitProvider>().setTagSelected("All");
          });
          pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );

          deleted = false;
          updated = false;
          editcontroller.clear();
          changed = false;
          if (context.mounted) {
            Provider.of<HabitProvider>(context, listen: false).updatedIcon =
                startIcon;
            Provider.of<HabitProvider>(context, listen: false).habitGoalValue =
                0;
          }
        });
      },
      child: Slidable(
        enabled: habit.completed ? habit.skipped : true,
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
              label: habit.skipped ? 'Undo' : 'Skip',
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
          habit: habit,
          interstitialAd: widget.interstitialAd,
          isAdLoaded: widget.isAdLoaded,
        ),
      ),
    );
  }
}

class HabitTile extends StatelessWidget {
  const HabitTile(
      {super.key,
      required this.index,
      required this.habitBox,
      required this.widget,
      required this.amountCheck,
      required this.durationCheck,
      required this.habit,
      required this.isAdLoaded,
      required this.interstitialAd});

  final int index;
  final Box<HabitData> habitBox;
  final NewHabitTile widget;
  final bool amountCheck;
  final bool durationCheck;
  final HabitData habit;
  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        getIcon(index),
        color: habit.completed ? Colors.grey.shade700 : Colors.white,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              habit.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: textStyleCompletedCheck(),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IntrinsicWidth(
              stepWidth: 10,
              child: StreakDisplay(habitBox: habitBox, index: index)),
        ],
      ),
      trailing: CheckBox(
        amountCheck: amountCheck,
        durationCheck: durationCheck,
        habitBox: habitBox,
        index: index,
        habit: habit,
        isAdLoaded: isAdLoaded,
        interstitialAd: interstitialAd,
      ),
    );
  }

  TextStyle textStyleCompletedCheck() {
    return TextStyle(
        color: habit.completed ? Colors.grey.shade700 : Colors.white,
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
        offset: const Offset(0, 2),
        child: AnimatedDigitWidget(
          loop: false,
          duration: const Duration(milliseconds: 800),
          value: habitBox.getAt(index)!.skipped
              ? habitBox.getAt(index)!.streak
              : habitBox.getAt(index)!.completed
                  ? habitBox.getAt(index)!.streak + 1
                  : habitBox.getAt(index)!.streak,
          textStyle: const TextStyle(fontFamily: "Poppins", fontSize: 14),
          valueColors: [
            ValueColor(
              condition: () => habitBox.getAt(index)!.completed,
              color: Colors.white,
            ),
            ValueColor(
              condition: () => !habitBox.getAt(index)!.completed,
              color: Colors.grey,
            ),
          ],
        ),
      )
    ]);
  }
}

class CheckBox extends StatefulWidget {
  const CheckBox(
      {super.key,
      required this.amountCheck,
      required this.durationCheck,
      required this.habitBox,
      required this.index,
      required this.habit,
      required this.interstitialAd,
      required this.isAdLoaded});

  final bool amountCheck;
  final bool durationCheck;
  final Box<HabitData> habitBox;
  final int index;
  final HabitData habit;
  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        checkCompleteHabit(widget.amountCheck, widget.durationCheck,
            widget.index, context, widget.isAdLoaded, widget.interstitialAd);
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
          child: widget.habitBox.getAt(widget.index)!.completed &&
                  !widget.habitBox.getAt(widget.index)!.skipped
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
                              end:
                                  widget.habitBox.getAt(widget.index)!.completed
                                      ? 1
                                      : 0,
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
                                  end: widget.habitBox
                                          .getAt(widget.index)!
                                          .amountCompleted /
                                      widget.habitBox
                                          .getAt(widget.index)!
                                          .amount,
                                ),
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    color: widget.habitBox
                                            .getAt(widget.index)!
                                            .skipped
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
                                  widget.habitBox
                                      .getAt(widget.index)!
                                      .amountCompleted
                                      .toString(),
                                  style: TextStyle(
                                      color: widget.habitBox
                                              .getAt(widget.index)!
                                              .skipped
                                          ? Colors.grey
                                          : Colors.white,
                                      fontSize: 10),
                                ),
                              ),
                              Divider(
                                color:
                                    widget.habitBox.getAt(widget.index)!.skipped
                                        ? Colors.grey
                                        : Colors.white,
                                thickness: 1,
                                indent: 15,
                                endIndent: 15,
                              ),
                              Transform.translate(
                                offset: const Offset(0, -3),
                                child: Text(
                                  widget.habitBox
                                      .getAt(widget.index)!
                                      .amount
                                      .toString(),
                                  style: TextStyle(
                                      color: widget.habitBox
                                              .getAt(widget.index)!
                                              .skipped
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
                                      end: widget.habitBox
                                              .getAt(widget.index)!
                                              .durationCompleted /
                                          widget.habitBox
                                              .getAt(widget.index)!
                                              .duration,
                                    ),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        color: widget.habitBox
                                                .getAt(widget.index)!
                                                .skipped
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
                                      style: TextStyle(
                                          color: widget.habitBox
                                                  .getAt(widget.index)!
                                                  .skipped
                                              ? Colors.grey
                                              : Colors.white,
                                          fontSize: 10),
                                    ),
                                  ),
                                  Divider(
                                    color: widget.habitBox
                                            .getAt(widget.index)!
                                            .skipped
                                        ? Colors.grey
                                        : Colors.white,
                                    thickness: 1,
                                    indent: 15,
                                    endIndent: 15,
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -3),
                                    child: Text(
                                      widget.habitBox
                                                      .getAt(widget.index)!
                                                      .duration ~/
                                                  60 ==
                                              0
                                          ? "${widget.habitBox.getAt(widget.index)!.duration % 60}m"
                                          : widget.habitBox
                                                          .getAt(widget.index)!
                                                          .duration %
                                                      60 ==
                                                  0
                                              ? "${widget.habitBox.getAt(widget.index)!.duration ~/ 60}h"
                                              : "${widget.habitBox.getAt(widget.index)!.duration ~/ 60}h${widget.habitBox.getAt(widget.index)!.duration % 60}m",
                                      style: TextStyle(
                                          color: widget.habitBox
                                                  .getAt(widget.index)!
                                                  .skipped
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
                                      end: widget.habitBox
                                              .getAt(widget.index)!
                                              .completed
                                          ? 1
                                          : 0,
                                    ),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        color: widget.habitBox
                                                .getAt(widget.index)!
                                                .skipped
                                            ? Colors.grey.shade800
                                            : theOtherColor,
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

void checkCompleteHabit(amountCheck, durationCheck, int index,
    BuildContext context, bool isAdLoaded, interstitialAd) {
  if (amountCheck == true || durationCheck == true) {
    if (habitBox.getAt(index)!.completed) {
      context
          .read<HabitProvider>()
          .completeHabitProvider(index, isAdLoaded, interstitialAd);
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              completeHabitDialog(index, isAdLoaded, interstitialAd));
    }
  } else {
    context
        .read<HabitProvider>()
        .completeHabitProvider(index, isAdLoaded, interstitialAd);
  }
}
