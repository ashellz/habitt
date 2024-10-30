import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/showCustomDialog.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.keyboardOpen,
    required this.index,
    required this.editcontroller,
  });

  final bool keyboardOpen;
  final int index;
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
              backgroundColor: AppColors.theLightColor,
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
                final appearanceEdited =
                    Provider.of<HabitProvider>(context, listen: false)
                        .appearenceEdited;
                final isFirstTimeEdit = boolBox.get("firstTimeEditAppearence")!;

                if (appearanceEdited && isFirstTimeEdit) {
                  showCustomDialog(
                      context,
                      "Edit Habit",
                      Text(
                          boolBox.get("editHistoricalHabits")!
                              ? "The changes will affect this habit in the past. You can change this in settings."
                              : "The changes won't affect this habit in the past. You can change this in settings.",
                          textAlign: TextAlign.center),
                      () => Provider.of<HabitProvider>(context, listen: false)
                          .editHabitProvider(index, context, editcontroller),
                      "Edit",
                      "Cancel");
                } else {
                  Provider.of<HabitProvider>(context, listen: false)
                      .editHabitProvider(index, context, editcontroller);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
