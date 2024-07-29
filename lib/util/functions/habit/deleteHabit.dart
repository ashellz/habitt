import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/habit/edit_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/util/functions/habit/checkCategory.dart';
import 'package:habit_tracker/util/functions/habit/checkIfEmpty.dart';
import 'package:hive/hive.dart';

var habitListLenght = Hive.box<HabitData>('habits').length;
late String category;

Future<void> deleteHabit(int index, context, editcontroller) async {
  category = checkCategory(habitBox.getAt(index)!.category.toString());

  habitBox.deleteAt(index);
  habitListLenght = habitBox.length;
  checkIfEmpty(category);

  deleted = true;
  editcontroller.text = "";
  await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const NewHomePage()));

  habitGoalEdit = 0;
  updated = false;
  dropDownChanged = false;
  editcontroller.clear();
  changed = false;
  updatedIcon = startIcon;
}
