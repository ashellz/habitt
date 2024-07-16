import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/habit/edit_habit_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/util/functions/habit/checkCategory.dart';
import 'package:habit_tracker/util/functions/habit/checkIfEmpty.dart';
import 'package:hive/hive.dart';

var habitListLenght = Hive.box<HabitData>('habits').length;
late String category;

Future<void> deleteHabit(int index, context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: theGreen,
        content: SizedBox(
          height: 122,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Are you sure you want to delete this habit?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theRedColor,
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      category = checkCategory(
                          habitBox.getAt(index)!.category.toString());
                      updateHeightDelete(index);
                      habitBox.deleteAt(index);
                      habitListLenght = habitBox.length;
                      checkIfEmpty(category);

                      deleted = true;
                      editcontroller.text = "";
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));

                      habitGoalEdit = 0;
                      updated = false;
                      dropDownChanged = false;
                      editcontroller.clear();
                      changed = false;
                      updatedIcon = startIcon;

                      //Navigator.of(context).pop();
                      // showPopup(context, "Habit deleted!");
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theLightGreen,
                    ),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void updateHeightDelete(index) {
  if (habitBox.getAt(index)!.category == "Morning") {
    morningHeight -= 82;
  } else if (habitBox.getAt(index)!.category == "Afternoon") {
    afternoonHeight -= 82;
  } else if (habitBox.getAt(index)!.category == "Evening") {
    eveningHeight -= 82;
  } else if (habitBox.getAt(index)!.category == "Any time") {
    anyTimeHeight -= 82;
  }
}
