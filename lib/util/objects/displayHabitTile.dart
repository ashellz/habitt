import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/icons_page.dart';
import 'package:habit_tracker/util/functions/getIcon.dart';
import 'package:habit_tracker/util/objects/editHabit.dart';
import 'package:hive_flutter/hive_flutter.dart';

final habitBox = Hive.box<HabitData>('habits');
final _formKey = GlobalKey<FormState>();

class HabitTile extends StatelessWidget {
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
    if (habitBox.getAt(index)!.streak >= 2) {
      if (habitBox.getAt(index)!.completed == true) {
        return Text(
          habitBox.getAt(index)!.completed
              ? "${habitBox.getAt(index)!.streak + 1} days streak"
              : "${habitBox.getAt(index)!.streak} days streak",
          style: const TextStyle(
              color: Color.fromARGB(255, 37, 67, 54),
              fontWeight: FontWeight.bold,
              fontSize: 15),
        );
      } else {
        return Text("${habitBox.getAt(index)!.streak} days streak");
      }
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    IconData displayIcon = getIcon(index);
    return Column(
      children: [
        const SizedBox(height: 10),
        Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.30,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => checkTask(index),
                backgroundColor: const Color.fromARGB(255, 37, 67, 54),
                foregroundColor: Colors.white,
                label: habitBox.getAt(index)!.completed ? 'Undo' : 'Done',
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
                dropDownValue = habitBox.getAt(index)!.category;
                return editHabit(
                    _formKey, _validateText, deletetask, edittask, index);
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
                color: habitBox.getAt(index)!.completed
                    ? Colors.grey.shade600
                    : Colors.grey.shade800,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    truncatedText(index),
                    style: TextStyle(
                        color: habitBox.getAt(index)!.completed
                            ? Colors.grey.shade600
                            : Colors.black,
                        decoration: habitBox.getAt(index)!.completed
                            ? TextDecoration.lineThrough
                            : null),
                  ),
                  streakWidget(),
                ],
              ),
              trailing: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: habitBox.getAt(index)!.completed
                      ? const Color.fromARGB(255, 37, 67, 54)
                      : const Color.fromARGB(255, 183, 181, 151),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                    habitBox.getAt(index)!.completed
                        ? Icons.check
                        : Icons.close,
                    color: habitBox.getAt(index)!.completed
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
