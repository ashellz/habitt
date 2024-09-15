import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.keyboardOpen,
    required this.widget,
    required this.editcontroller,
  });

  final bool keyboardOpen;
  final EditHabitPage widget;
  final TextEditingController editcontroller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<HabitProvider>().somethingEdited,
      child: Transform.translate(
        offset: Offset(0, keyboardOpen ? 100 : 0),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theLightColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
            ),
            child: const Text('Save Changes',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Provider.of<HabitProvider>(context, listen: false)
                    .editHabitProvider(widget.index, context, editcontroller);
              }
            },
          ),
        ),
      ),
    );
  }
}
