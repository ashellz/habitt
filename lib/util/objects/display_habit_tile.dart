import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/edit_habit_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

final habitBox = Hive.box<HabitData>('habits');
final _formKey = GlobalKey<FormState>();

class HabitTile extends StatefulWidget {
  const HabitTile({
    super.key,
    required this.edithabit,
    required this.deletehabit,
    required this.index,
    required this.checkHabit,
  });

  final int index;
  final Future<void> Function(int index) deletehabit;
  final void Function(int index) edithabit;
  final void Function(int index) checkHabit;

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  void popmenu(BuildContext context) {
    Navigator.pop(context);
  }

  String? validateText(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter some text';
    }
    return null;
  }

  String truncatedText(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    int maxLength;

    if (screenWidth < 300) {
      maxLength = 10; // very small screen
    } else if (screenWidth < 400) {
      maxLength = 18; // small screen
    } else if (screenWidth < 500) {
      maxLength = 20; // medium screen
    } else {
      maxLength = 35; // larger screen
    }

    String name = habitBox.getAt(index)!.name;
    if (name.length > maxLength) {
      return '${name.substring(0, maxLength)}...';
    }
    return name;
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
    int theAmountValue = habitBox.getAt(widget.index)!.amountCompleted;
    int theDurationValue = habitBox.getAt(widget.index)!.durationCompleted;

    bool amountCheck = false;

    if (habitBox.getAt(widget.index)!.amount > 1) amountCheck = true;

    return Column(
      children: [
        const SizedBox(height: 10),
        Slidable(
          endActionPane: ActionPane(
            extentRatio: habitBox.getAt(widget.index)!.completed
                ? 0.320
                : habitBox.getAt(widget.index)!.amount <= 1 &&
                        habitBox.getAt(widget.index)!.duration <= 0
                    ? 0.320
                    : 0.60,
            motion: const ScrollMotion(),
            children: [
              if (habitBox.getAt(widget.index)!.completed == false)
                if (habitBox.getAt(widget.index)!.duration > 0 ||
                    habitBox.getAt(widget.index)!.amount > 1)
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 22)),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NumberPicker(
                                  axis: Axis.horizontal,
                                  itemWidth:
                                      MediaQuery.of(context).size.width / 4.5,
                                  minValue: 0,
                                  maxValue: amountCheck
                                      ? habitBox.getAt(widget.index)!.amount - 1
                                      : habitBox.getAt(widget.index)!.duration -
                                          1,
                                  value: amountCheck
                                      ? theAmountValue
                                      : theDurationValue,
                                  onChanged: (value) {
                                    mystate(() {
                                      if (amountCheck) {
                                        theAmountValue = value;
                                      } else {
                                        theDurationValue = value;
                                      }
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
                                        if (amountCheck) {
                                          applyAmountCompleted(
                                              widget.index, theAmountValue);
                                        } else {
                                          applyDurationCompleted(
                                              widget.index, theDurationValue);
                                        }
                                      });
                                      setState(() {
                                        if (amountCheck) {
                                          applyAmountCompleted(
                                              widget.index, theAmountValue);
                                        } else {
                                          applyDurationCompleted(
                                              widget.index, theDurationValue);
                                        }
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
                onPressed: (context) => widget.checkHabit(widget.index),
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
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditHabitPage(
                          index: widget.index,
                          deletehabit: widget.deletehabit,
                          edithabit: widget.edithabit,
                        )))
                .whenComplete(() {
              habitGoalEdit = 0;
              updated = false;
              dropDownChanged = false;
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
                        truncatedText(context, widget.index),
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
                  if (amountCheck)
                    SizedBox(
                      width: 60,
                      child: Column(
                        children: [
                          Text(
                            "$theAmountValue/${habitBox.getAt(widget.index)!.amount}",
                            style: TextStyle(
                                color: habitBox.getAt(widget.index)!.completed
                                    ? const Color.fromARGB(255, 37, 67, 54)
                                    : Colors.black,
                                fontWeight:
                                    habitBox.getAt(widget.index)!.completed
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                          ),
                          Text(
                            habitBox.getAt(widget.index)!.amountName,
                            style: TextStyle(
                                fontSize: 12,
                                color: habitBox.getAt(widget.index)!.completed
                                    ? const Color.fromARGB(255, 37, 67, 54)
                                    : Colors.black,
                                fontWeight:
                                    habitBox.getAt(widget.index)!.completed
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                          ),
                        ],
                      ),
                    )
                  else if (habitBox.getAt(widget.index)!.duration > 0)
                    SizedBox(
                      width: 60,
                      child: Column(
                        children: [
                          Text(
                            "$theDurationValue/${habitBox.getAt(widget.index)!.duration}",
                            style: TextStyle(
                              color: habitBox.getAt(widget.index)!.completed
                                  ? const Color.fromARGB(255, 37, 67, 54)
                                  : Colors.black,
                              fontWeight:
                                  habitBox.getAt(widget.index)!.completed
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          Text(
                            habitBox.getAt(widget.index)!.duration == 1
                                ? "minute"
                                : "minutes",
                            style: TextStyle(
                                fontSize: 12,
                                color: habitBox.getAt(widget.index)!.completed
                                    ? const Color.fromARGB(255, 37, 67, 54)
                                    : Colors.black,
                                fontWeight:
                                    habitBox.getAt(widget.index)!.completed
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                          ),
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

applyDurationCompleted(index, theDurationValue) {
  habitBox.putAt(
      index,
      HabitData(
          name: habitBox.getAt(index)!.name,
          completed: habitBox.getAt(index)!.completed,
          icon: habitBox.getAt(index)!.icon,
          category: habitBox.getAt(index)!.category,
          streak: habitBox.getAt(index)!.streak,
          amount: habitBox.getAt(index)!.amount,
          amountName: habitBox.getAt(index)!.amountName,
          amountCompleted: habitBox.getAt(index)!.amountCompleted,
          duration: habitBox.getAt(index)!.duration,
          durationCompleted: theDurationValue));
}

applyAmountCompleted(index, theAmountValue) {
  habitBox.putAt(
      index,
      HabitData(
          name: habitBox.getAt(index)!.name,
          completed: habitBox.getAt(index)!.completed,
          icon: habitBox.getAt(index)!.icon,
          category: habitBox.getAt(index)!.category,
          streak: habitBox.getAt(index)!.streak,
          amount: habitBox.getAt(index)!.amount,
          amountName: habitBox.getAt(index)!.amountName,
          amountCompleted: theAmountValue,
          duration: habitBox.getAt(index)!.duration,
          durationCompleted: habitBox.getAt(index)!.durationCompleted));
}
