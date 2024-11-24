import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/objects/habit/Complete%20Habit%20Dialog/complete_habit_dialog.dart';
import 'package:hive/hive.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';

class NewHabitTile extends StatefulWidget {
  const NewHabitTile({
    super.key,
    required this.id,
    required this.editcontroller,
    required this.isAdLoaded,
    required this.interstitialAd,
  });
  final int id;
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
    var editcontroller = widget.editcontroller;
    int id = widget.id;
    int habitIndex = context.read<HabitProvider>().getIndexFromId(id);
    var habit = context.read<HabitProvider>().getHabitAt(id);
    bool amountCheck = false;
    bool durationCheck = false;

    if (habit.amount > 1) {
      amountCheck = true;
    } else if (habit.duration > 0) {
      durationCheck = true;
    }

    return GestureDetector(
      onTap: () {
        context.read<HabitProvider>().resetSomethingEdited();
        context.read<HabitProvider>().resetAppearenceEdited();
        Provider.of<HabitProvider>(context, listen: false).habitGoalValue = 0;
        updated = false;
        editcontroller.text = "";
        changed = false;
        deleted = false;

        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => EditHabitPage(
                      id: id,
                      editcontroller: editcontroller,
                    )))
            .whenComplete(() {
          bool changeTag = true;
          for (int i = 0; i < tagBox.length; i++) {
            if (tagBox.getAt(i)!.tag == habit.tag) {
              changeTag = false;
              break;
            }
          }
          if (changeTag) {
            habit.tag = habitTag;
            changeTag = true;
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<HabitProvider>().setTagSelected(
                "All"); //TODO: only change if selected tag is deleted
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
            context.read<HabitProvider>().changeNotification([]);
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
                context.read<HabitProvider>().skipHabitProvider(habitIndex);
              },
              backgroundColor: context.watch<ColorProvider>().greyColor,
              foregroundColor: Colors.white,
              label: habit.skipped ? 'Undo' : 'Skip',
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: HabitTile(
          index: habitIndex,
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
      required this.widget,
      required this.amountCheck,
      required this.durationCheck,
      required this.habit,
      required this.isAdLoaded,
      required this.interstitialAd});

  final int index;
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
          IntrinsicWidth(stepWidth: 10, child: StreakDisplay(habit: habit)),
        ],
      ),
      trailing: CheckBox(
        amountCheck: amountCheck,
        durationCheck: durationCheck,
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
        decoration: habitBox.getAt(index)!.completed
            ? TextDecoration.lineThrough
            : null,
        decorationColor: Colors.grey.shade700,
        decorationThickness: 3.0);
  }
}

class StreakDisplay extends StatelessWidget {
  const StreakDisplay({
    super.key,
    required this.habit,
  });

  final HabitData habit;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        MaterialCommunityIcons.fire,
        color: habit.completed ? Colors.white : Colors.grey,
        size: 21,
      ),
      Transform.translate(
        offset: const Offset(0, 2),
        child: AnimatedDigitWidget(
          loop: false,
          duration: const Duration(milliseconds: 800),
          value: habit.skipped
              ? habit.streak
              : habit.completed
                  ? habit.streak + 1
                  : habit.streak,
          textStyle: const TextStyle(fontFamily: "Poppins", fontSize: 14),
          valueColors: [
            ValueColor(
              condition: () => habit.completed,
              color: Colors.white,
            ),
            ValueColor(
              condition: () => !habit.completed,
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
      required this.index,
      required this.habit,
      required this.interstitialAd,
      required this.isAdLoaded});

  final bool amountCheck;
  final bool durationCheck;
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
            color: widget.habit.completed
                ? AppColors.theOtherColor
                : context.watch<ColorProvider>().greyColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: widget.habit.completed && !widget.habit.skipped
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
                              end: widget.habit.completed ? 1 : 0,
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
                                  end: widget.habit.amountCompleted /
                                      widget.habit.amount,
                                ),
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    value: value,
                                    color: widget.habit.skipped
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
                                  widget.habit.amountCompleted.toString(),
                                  style: TextStyle(
                                      color: widget.habit.skipped
                                          ? Colors.grey
                                          : Colors.white,
                                      fontSize: 10),
                                ),
                              ),
                              Divider(
                                color: widget.habit.skipped
                                    ? Colors.grey
                                    : Colors.white,
                                thickness: 1,
                                indent: 15,
                                endIndent: 15,
                              ),
                              Transform.translate(
                                offset: const Offset(0, -3),
                                child: Text(
                                  widget.habit.amount.toString(),
                                  style: TextStyle(
                                      color: widget.habit.skipped
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
                                      end: widget.habit.durationCompleted /
                                          widget.habit.duration,
                                    ),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        color: widget.habit.skipped
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
                                      widget.habit.durationCompleted ~/ 60 == 0
                                          ? "${widget.habit.durationCompleted % 60}m"
                                          : widget.habit.durationCompleted %
                                                      60 ==
                                                  0
                                              ? "${widget.habit.durationCompleted ~/ 60}h"
                                              : "${widget.habit.durationCompleted ~/ 60}h${widget.habit.durationCompleted % 60}m",
                                      style: TextStyle(
                                          color: widget.habit.skipped
                                              ? Colors.grey
                                              : Colors.white,
                                          fontSize: 10),
                                    ),
                                  ),
                                  Divider(
                                    color: widget.habit.skipped
                                        ? Colors.grey
                                        : Colors.white,
                                    thickness: 1,
                                    indent: 15,
                                    endIndent: 15,
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -3),
                                    child: Text(
                                      widget.habit.duration ~/ 60 == 0
                                          ? "${widget.habit.duration % 60}m"
                                          : widget.habit.duration % 60 == 0
                                              ? "${widget.habit.duration ~/ 60}h"
                                              : "${widget.habit.duration ~/ 60}h${widget.habit.duration % 60}m",
                                      style: TextStyle(
                                          color: widget.habit.skipped
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
                                      end: widget.habit.completed ? 1 : 0,
                                    ),
                                    builder: (context, value, _) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        color: widget.habit.skipped
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

void checkCompleteHabit(amountCheck, durationCheck, int index,
    BuildContext context, bool isAdLoaded, interstitialAd) {
  if (amountCheck == true || durationCheck == true) {
    if (habitBox.getAt(index)!.completed) {
      context
          .read<HabitProvider>()
          .completeHabitProvider(index, isAdLoaded, interstitialAd, context);
    } else {
      completeHabitDialog(index, isAdLoaded, interstitialAd, context);
    }
  } else {
    context
        .read<HabitProvider>()
        .completeHabitProvider(index, isAdLoaded, interstitialAd, context);
  }
}
