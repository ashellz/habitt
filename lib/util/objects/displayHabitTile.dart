import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/util/functions/getIcon.dart';
import 'package:habit_tracker/util/objects/editHabit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

final habitBox = Hive.box<HabitData>('habits');
final _formKey = GlobalKey<FormState>();

class HabitTile extends StatefulWidget {
  const HabitTile({
    super.key,
    required this.edittask,
    required this.deletetask,
    required this.index,
    required this.checkTask,
  });

  final int index;
  final Future<void> Function(int index) deletetask;
  final void Function(int index) edittask;
  final void Function(int index) checkTask;

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  void popmenu(BuildContext context) {
    Navigator.pop(context);
  }

  String? _validateText(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter some text';
    }
    return null;
  }

  String truncatedText(index) {
    if (habitBox.getAt(index)!.name.length > 22) {
      return '${habitBox.getAt(index)!.name.substring(0, 22)}...';
    }
    return habitBox.getAt(index)!.name;
  }

  Widget streakWidget() {
    if (habitBox.getAt(widget.index)!.streak >= 1) {
      if (habitBox.getAt(widget.index)!.completed == true) {
        return Text(
          "${habitBox.getAt(widget.index)!.streak + 1} days streak",
          style: const TextStyle(
              color: Color.fromARGB(255, 37, 67, 54),
              fontWeight: FontWeight.bold,
              fontSize: 15),
        );
      } else if (habitBox.getAt(widget.index)!.streak != 1) {
        return Text("${habitBox.getAt(widget.index)!.streak} days streak");
      }
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    IconData displayIcon = getIcon(widget.index);
    int theValue = habitBox.getAt(widget.index)!.amountCompleted;

    return Column(
      children: [
        const SizedBox(height: 10),
        Slidable(
          endActionPane: ActionPane(
            extentRatio: habitBox.getAt(widget.index)!.completed
                ? 0.275
                : habitBox.getAt(widget.index)!.amount <= 1 &&
                        habitBox.getAt(widget.index)!.duration <= 0
                    ? 0.275
                    : 0.50,
            motion: const ScrollMotion(),
            children: [
              if (habitBox.getAt(widget.index)!.completed == false &&
                      habitBox.getAt(widget.index)!.amount > 1 ||
                  habitBox.getAt(widget.index)!.duration > 0)
                SlidableAction(
                  onPressed: (context) => showDialog(
                    context: context,
                    builder: (BuildContext context) => StatefulBuilder(
                      builder: (BuildContext context, StateSetter mystate) =>
                          AlertDialog(
                        backgroundColor:
                            const Color.fromARGB(255, 218, 211, 190),
                        title: const Center(
                          child: Text("Enter amount",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 22)),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NumberPicker(
                                axis: Axis.horizontal,
                                minValue: 1,
                                maxValue: habitBox.getAt(widget.index)!.amount -
                                    1, // change to support duration too
                                value: theValue == 0 ? 1 : theValue,
                                onChanged: (value) {
                                  mystate(() {
                                    theValue = value;
                                  });
                                }),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 37, 67, 54),
                                  ),
                                  onPressed: () {
                                    mystate(() {
                                      habitBox
                                              .getAt(widget.index)!
                                              .amountCompleted =
                                          theValue == 0 ? 1 : theValue;
                                    });
                                    setState(() {
                                      habitBox
                                              .getAt(widget.index)!
                                              .amountCompleted =
                                          theValue == 0 ? 1 : theValue;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Enter",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 37, 67, 54),
                  foregroundColor: Colors.white,
                  label: 'Enter',
                  borderRadius: BorderRadius.circular(15),
                ),
              const SizedBox(width: 5),
              SlidableAction(
                onPressed: (context) => widget.checkTask(widget.index),
                backgroundColor: const Color.fromARGB(255, 37, 67, 54),
                foregroundColor: Colors.white,
                label:
                    habitBox.getAt(widget.index)!.completed ? 'Undo' : 'Done',
                borderRadius: BorderRadius.circular(15),
              ),
              const SizedBox(width: 10),
            ],
          ),
          child: GestureDetector(
            onTap: () => showModalBottomSheet(
              enableDrag: true,
              context: context,
              backgroundColor: const Color.fromARGB(255, 218, 211, 190),
              builder: (BuildContext context) {
                dropDownValue = habitBox.getAt(widget.index)!.category;
                return editHabit(_formKey, _validateText, widget.deletetask,
                    widget.edittask, widget.index);
              },
            ).whenComplete(() {
              editcontroller.clear();
              changed = false;
              updatedIcon = startIcon;
            }),
            child: ListTile(
              minTileHeight: 65,
              contentPadding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 2.0,
              ),
              leading: Icon(
                displayIcon,
                color: habitBox.getAt(widget.index)!.completed
                    ? Colors.grey.shade600
                    : Colors.grey.shade800,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truncatedText(widget.index),
                        style: TextStyle(
                            color: habitBox.getAt(widget.index)!.completed
                                ? Colors.grey.shade600
                                : Colors.black,
                            decoration: habitBox.getAt(widget.index)!.completed
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      streakWidget(),
                    ],
                  ),
                  if (habitBox.getAt(widget.index)!.amount > 1)
                    SizedBox(
                      width: 53,
                      child: Column(
                        children: [
                          Text(
                              "$theValue/${habitBox.getAt(widget.index)!.amount}") //-------- HAVE TO CHANGE THE 0 HERE
                          ,
                          const Text(
                            "times",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    )
                  else if (habitBox.getAt(widget.index)!.duration > 0)
                    SizedBox(
                      width: 53,
                      child: Column(
                        children: [
                          Text(
                              "0/${habitBox.getAt(widget.index)!.duration}") //-------- HAVE TO CHANGE THE 0 HERE
                          ,
                          const Text(
                            "minutes",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    )
                ],
              ),
              trailing: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: habitBox.getAt(widget.index)!.completed
                      ? const Color.fromARGB(255, 37, 67, 54)
                      : const Color.fromARGB(255, 183, 181, 151),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                    habitBox.getAt(widget.index)!.completed
                        ? Icons.check
                        : Icons.close,
                    color: habitBox.getAt(widget.index)!.completed
                        ? Colors.white
                        : Colors.grey.shade800),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
