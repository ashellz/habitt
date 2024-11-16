import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/shared%20widgets/additional_task.dart';
import 'package:habitt/pages/habit/shared%20widgets/choose_tag.dart';
import 'package:habitt/pages/habit/shared%20widgets/dropdown_menu.dart';
import 'package:habitt/pages/habit/shared%20widgets/habit_goal.dart';
import 'package:habitt/pages/habit/shared%20widgets/habit_name_textfield.dart';
import 'package:habitt/pages/habit/shared%20widgets/habit_type.dart';
import 'package:habitt/pages/habit/shared%20widgets/notes_text_field.dart';

Widget editPage(
    StateSetter setState,
    BuildContext context,
    TextEditingController editcontroller,
    TextEditingController desccontroller,
    TextEditingController habitTypeController,
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

    //HABIT TYPE
    HabitType(isEdit: true),

    // HABIT GOAL
    HabitGoal(index: index, isEdit: true),

    const AdditionalTask(
      isEdit: true,
    )
  ]);
}
