import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/habit/Shared%20Widgets/choose_tag.dart';
import 'package:habit_tracker/pages/habit/Shared%20Widgets/dropdown_menu.dart';
import 'package:habit_tracker/pages/habit/Shared%20Widgets/habit_goal.dart';
import 'package:habit_tracker/pages/habit/Shared%20Widgets/habit_name_textfield.dart';
import 'package:habit_tracker/pages/habit/Shared%20Widgets/notes_text_field.dart';

Widget editPage(
    StateSetter setState,
    BuildContext context,
    TextEditingController editcontroller,
    TextEditingController desccontroller,
    int index) {
  return Column(children: [
    //TAG

    const ChooseTag(
      isEdit: true,
    ),

    //NAME

    HabitNameTextField(controller: editcontroller, isEdit: true),

    //NOTES

    const NotesTextField(),

    //DROPDOWN MENU

    const DropDownMenu(),
    const SizedBox(height: 15),

    // HABIT GOAL
    HabitGoal(index: index, isEdit: true),
  ]);
}
