import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/icons_page.dart';
import 'package:habit_tracker/util/functions/getIcon.dart';
import 'package:hive/hive.dart';

final habitBox = Hive.box<HabitData>('habits');

Widget editHabit(formKey, validateText, deletetask, edithabit, index) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) {
      if (!changed) {
        updatedIcon = Icon(getIcon(index));
      }
      if (editcontroller.text.isEmpty) {
        editcontroller.text = habitBox.getAt(index)!.name;
      }
      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        left: 25.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        "Habit Info",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 25.0),
                      child: Text(
                        habitBox.getAt(index)!.completed
                            ? "Streak ${habitBox.getAt(index)!.streak + 1}"
                            : "Streak ${habitBox.getAt(index)!.streak}",
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    validator: validateText,
                    controller: editcontroller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IconsPage(),
                            ),
                          ).then((value) => mystate(() {
                                updatedIcon = theIcon;
                                changed = true;
                              }));
                        },
                        icon: updatedIcon,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(
                          255, 183, 181, 151), // Apply background color
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      dropdownColor: const Color.fromARGB(255, 218, 211, 190),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 218, 211, 190),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      value: habitBox.getAt(index)!.category,
                      items: dropdownItems,
                      onChanged: (String? newValue) {
                        mystate(() {
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await deletetask(index);
                          if (deleted) {
                            Navigator.pop(context);
                            deleted = false;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 152, 26, 51),
                          shape: const StadiumBorder(),
                          minimumSize:
                              const Size(120, 50), // Increase button size
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            edithabit(index);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 37, 67, 54),
                          shape: const StadiumBorder(),
                          minimumSize:
                              const Size(120, 50), // Increase button size
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
