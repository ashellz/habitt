import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/services/provider/historical_habit_provider.dart';
import 'package:habitt/util/colors.dart';
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
                final appearanceEdited =
                    Provider.of<HabitProvider>(context, listen: false)
                        .appearenceEdited;
                final isFirstTimeEdit = boolBox.get("firstTimeEditAppearence")!;

                if (appearanceEdited && isFirstTimeEdit) {
                  showDialog(
                      context: context,
                      builder: (context) => EditPastHabits(
                          widget: widget, editcontroller: editcontroller));
                } else {
                  Provider.of<HabitProvider>(context, listen: false)
                      .editHabitProvider(widget.index, context, editcontroller);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class EditPastHabits extends StatelessWidget {
  const EditPastHabits({
    super.key,
    required this.widget,
    required this.editcontroller,
  });

  final EditHabitPage widget;
  final TextEditingController editcontroller;

  @override
  Widget build(BuildContext context) {
    String text = "The changes will affect this habit in the past.";

    if (!boolBox.get("editHistoricalHabits")!) {
      text = "The changes won't affect this habit in the past.";
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: Colors.grey.shade900, width: 3.0),
      ),
      backgroundColor: Colors.black,
      title: Center(
        child: RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
              ),
            ),
            const TextSpan(
                text: " You can change this in settings.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: "Poppins",
                )),
          ]),
        ),
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            width: 100,
            child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 2.0, color: Colors.grey.shade800),
                ),
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 14))),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 100,
            child: ElevatedButton(
                onPressed: () async {
                  boolBox.put("firstTimeEditAppearence", false);
                  Navigator.pop(context);
                  Provider.of<HabitProvider>(context, listen: false)
                      .editHabitProvider(widget.index, context, editcontroller);
                  if (boolBox.get("editHistoricalHabits")!) {
                    Provider.of<HistoricalHabitProvider>(context, listen: false)
                        .editHistoricalHabit(widget.index);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.grey.shade800),
                ),
                child: const Text(
                  "Okay",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
          ),
        ]),
      ],
    );
  }
}
