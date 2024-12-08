import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/showCustomDialog.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.index,
    required this.editcontroller,
  });

  final int index;
  final TextEditingController editcontroller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<HabitProvider>().somethingEdited,
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.theLightColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          ),
          child: Text(AppLocale.saveChanges.getString(context),
              style: const TextStyle(color: Colors.white)),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final appearanceEdited =
                  Provider.of<HabitProvider>(context, listen: false)
                      .appearenceEdited;
              final isFirstTimeEdit = boolBox.get("firstTimeEditAppearence")!;

              if (appearanceEdited && isFirstTimeEdit) {
                boolBox.put("firstTimeEditAppearence", false);
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
    );
  }
}
