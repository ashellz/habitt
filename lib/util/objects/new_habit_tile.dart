import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/habit/edit_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
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
      child: ListTile(
        leading: Icon(
          getIcon(index),
          color: Colors.white,
        ),
        title: Text(
          habitBox.getAt(index)!.name,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: GestureDetector(
          onTap: () => setState(() {
            context.read<HabitProvider>().completeHabitProvider(index);
          }),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: habit.completed ? theOtherGreen : Colors.grey.shade900,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(habit.completed ? Icons.check : Icons.close,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
