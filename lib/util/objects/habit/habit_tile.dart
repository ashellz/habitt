import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
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
                      habit: habit,
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
            context.read<DataProvider>().updateHabits(context);
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
                context
                    .read<HabitProvider>()
                    .skipHabitProvider(habitIndex, context);
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
    final TextSpan nameSpan = TextSpan(
        text: habit.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500));
    final dtp = TextPainter(text: nameSpan, textDirection: TextDirection.ltr);
    dtp.layout();
    final double nameWidth = dtp.width;

    return ListTile(
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Icon(
          key: ValueKey(habit.completed),
          getIconFromString(habit.icon),
          color: habit.completed ? Colors.grey.shade700 : Colors.white,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    key: ValueKey(habit.completed),
                    habit.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color:
                          habit.completed ? Colors.grey.shade700 : Colors.white,
                    ),
                  ),
                ),
                AnimatedHabitIndicator(
                    completed: habit.completed, nameWidth: nameWidth)
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IntrinsicWidth(
              stepWidth: 10, child: StreakDisplay(habit: habit, id: widget.id)),
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
}

class StreakDisplay extends StatefulWidget {
  const StreakDisplay({
    super.key,
    required this.habit,
    required this.id,
  });

  final HabitData habit;
  final int id;

  @override
  State<StreakDisplay> createState() => _StreakDisplayState();
}

class _StreakDisplayState extends State<StreakDisplay> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Icon(
          key: ValueKey(widget.habit.completed),
          MaterialCommunityIcons.fire,
          color: widget.habit.completed ? Colors.white : Colors.grey,
          size: 21,
        ),
      ),
      Transform.translate(
        offset: const Offset(0, 2),
        child: AnimatedDigitWidget(
          loop: false,
          duration: const Duration(milliseconds: 800),
          value: widget.habit.skipped
              ? widget.habit.streak
              : widget.habit.completed
                  ? widget.habit.streak + 1
                  : widget.habit.streak,
          textStyle: const TextStyle(fontFamily: "Poppins", fontSize: 14),
          valueColors: [
            ValueColor(
              condition: () => widget.habit.completed,
              color: Colors.white,
            ),
            ValueColor(
              condition: () => !widget.habit.completed,
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
  double _scale = 1.0;

  Widget centerIcon() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Center(
        key: ValueKey(widget.habit.completed),
        child: Icon(widget.habit.completed ? Icons.check : Icons.close,
            color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _scale = 0.9;
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _scale = 1.0;
          });
        });
        checkCompleteHabit(widget.amountCheck, widget.durationCheck,
            widget.index, context, widget.isAdLoaded, widget.interstitialAd);
      },
      onTapDown: (context) {
        setState(() {
          _scale = 0.9;
        });
      },
      onTapCancel: () => setState(() {
        _scale = 1.0;
      }),
      onTapUp: (context) => setState(() {
        _scale = 1.0;
      }),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _scale,
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
                      centerIcon()
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
                                        widget.habit.durationCompleted ~/ 60 ==
                                                0
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
                              centerIcon()
                            ],
                          )),
      ),
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

class AnimatedHabitIndicator extends StatefulWidget {
  final bool completed;
  final double nameWidth;

  const AnimatedHabitIndicator({
    required this.completed,
    required this.nameWidth,
  });

  @override
  _AnimatedHabitIndicatorState createState() => _AnimatedHabitIndicatorState();
}

class _AnimatedHabitIndicatorState extends State<AnimatedHabitIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _widthAnimation = Tween<double>(
      begin: 0,
      end: widget.completed ? widget.nameWidth + 10 : 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.grey.shade700,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.completed) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedHabitIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.completed != oldWidget.completed) {
      if (widget.completed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: const Offset(0, 1),
          child: Container(
            width: _widthAnimation.value,
            height: 2.5,
            color: _colorAnimation.value,
          ),
        );
      },
    );
  }
}
