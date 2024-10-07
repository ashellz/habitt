import 'package:flutter/material.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:provider/provider.dart';

Widget chooseCategory(String category, BuildContext context, bool isEdit) {
  return AnimatedOpacity(
    opacity: context.watch<HabitProvider>().categoryIsVisible ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 200),
    curve: Curves.fastOutSlowIn,
    child: Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 20),
      child: GestureDetector(
          onTap: () {
            context.read<HabitProvider>().updateDropDownValue(category);
            context.read<HabitProvider>().toggleExpansion();
            if (isEdit) {
              context.read<HabitProvider>().updateSomethingEdited();

              Provider.of<HabitProvider>(context, listen: false)
                  .updateAppearenceEdited();
            }
          },
          child: Text(
            category,
            style: const TextStyle(fontSize: 16),
          )),
    ),
  );
}
