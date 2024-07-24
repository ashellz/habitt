import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/habit/edit_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:habit_tracker/util/objects/complete_habit.dart';
import 'package:hive/hive.dart';
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
      onLongPress: () => print('Long Pressed'),
      child: ListTile(
        leading: Icon(
          getIcon(index),
          color: habitBox.getAt(index)!.completed
              ? Colors.grey.shade700
              : Colors.white,
        ),
        title: Text(
          habitBox.getAt(index)!.name,
          style: TextStyle(
              color: habitBox.getAt(index)!.completed
                  ? Colors.grey.shade700
                  : Colors.white,
              decoration: habitBox.getAt(widget.index)!.completed
                  ? TextDecoration.lineThrough
                  : null,
              decorationColor: Colors.grey.shade700,
              decorationThickness: 3.0),
        ),
        trailing: GestureDetector(
          onTap: () {
            if (amountCheck == true || durationCheck == true) {
              showDialog(
                  context: context,
                  builder: (context) => completeHabitDialog(index));
            } else {
              context.read<HabitProvider>().completeHabitProvider(index);
            }
          },
          child: Container(
              clipBehavior: Clip.hardEdge,
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: habit.completed ? theOtherGreen : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(15),
              ),
              child: habitBox.getAt(index)!.completed
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
                                  end: habitBox.getAt(index)!.completed ? 1 : 0,
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
                              habit.completed ? Icons.check : Icons.close,
                              color: Colors.white),
                        ),
                      ],
                    )
                  : amountCheck
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
                                      end: habitBox
                                              .getAt(index)!
                                              .amountCompleted /
                                          habitBox.getAt(index)!.amount,
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
                              child: Text(
                                "${habitBox.getAt(index)!.amountCompleted}/${habitBox.getAt(index)!.amount}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : durationCheck
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
                                          end: habitBox
                                                  .getAt(index)!
                                                  .durationCompleted /
                                              habitBox.getAt(index)!.duration,
                                        ),
                                        builder: (context, value, _) {
                                          return LinearProgressIndicator(
                                            value: value,
                                            color: theOtherGreen,
                                            backgroundColor:
                                                Colors.grey.shade900,
                                          );
                                        }),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "${habitBox.getAt(index)!.durationCompleted}/${habitBox.getAt(index)!.duration}",
                                    style: const TextStyle(color: Colors.white),
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
                                          end: habitBox.getAt(index)!.completed
                                              ? 1
                                              : 0,
                                        ),
                                        builder: (context, value, _) {
                                          return LinearProgressIndicator(
                                            value: value,
                                            color: theOtherGreen,
                                            backgroundColor:
                                                Colors.grey.shade900,
                                          );
                                        }),
                                  ),
                                ),
                                Center(
                                  child: Icon(
                                      habit.completed
                                          ? Icons.check
                                          : Icons.close,
                                      color: Colors.white),
                                ),
                              ],
                            )),
        ),
      ),
    );
  }
}
