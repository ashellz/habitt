import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:hive/hive.dart';

class NewHabitTile extends StatefulWidget {
  const NewHabitTile({super.key, required this.index});
  final int index;

  @override
  State<NewHabitTile> createState() => _NewHabitTileState();
}

class _NewHabitTileState extends State<NewHabitTile> {
  final habitBox = Hive.box<HabitData>('habits');

  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    return ListTile(
      leading: Icon(
        getIcon(index),
        color: Colors.white,
      ),
      title: Text(
        habitBox.getAt(index)!.name,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: habitBox.getAt(index)!.completed
              ? theOtherGreen
              : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
            habitBox.getAt(index)!.completed ? Icons.check : Icons.close,
            color: Colors.white),
      ),
    );
  }
}
