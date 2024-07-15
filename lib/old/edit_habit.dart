import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/icons_page.dart';
import 'package:habit_tracker/util/functions/habit/getIcon.dart';
import 'package:hive/hive.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:habit_tracker/util/functions/validate_text.dart';

final habitBox = Hive.box<HabitData>('habits');
int habitGoalEdit = 0;
late int amount;
late int duration;
bool updated = false;
TextEditingController amountNameControllerEdit = TextEditingController();
bool dropDownChanged = false;

Widget editHabit(formKey, deletetask, edithabit, index) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) {
      if (amountNameControllerEdit.text.isEmpty) {
        amountNameControllerEdit.text = "times";
      }

      if (!changed) {
        updatedIcon = Icon(getIcon(index));
      }
      if (editcontroller.text.isEmpty) {
        editcontroller.text = habitBox.getAt(index)!.name;
      }

      if (!updated) {
        if (habitBox.getAt(index)!.amount > 1) {
          habitGoalEdit = 1;
          amount = habitBox.getAt(index)!.amount;
          amountNameControllerEdit.text = habitBox.getAt(index)!.amountName;
          duration = 1;
        } else if (habitBox.getAt(index)!.duration > 0) {
          habitGoalEdit = 2;
          duration = habitBox.getAt(index)!.duration == 0
              ? 1
              : habitBox.getAt(index)!.duration;
          amount = habitBox.getAt(index)!.amount == 1
              ? 2
              : habitBox.getAt(index)!.amount;
        } else {
          habitGoalEdit = 0;
          amount = 2;
          duration = 1;
        }
        updated = true;
      }

      if (!dropDownChanged) dropDownValue = habitBox.getAt(index)!.category;

      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(35),
                    ],
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
                      fillColor: const Color.fromARGB(255, 183, 181, 151),
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
                          dropDownChanged = true;
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          mystate(() {
                            if (habitGoalEdit == 1) {
                              habitGoalEdit = 0;
                              habitBox.getAt(index)!.amount = 1;
                            } else {
                              amount = 2;
                              habitGoalEdit = 1;
                              habitBox.getAt(index)!.duration = 0;
                            }
                          });
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width * 0.42, 45)),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            habitGoalEdit == 1
                                ? const Color.fromARGB(255, 107, 138, 122)
                                : const Color.fromARGB(255, 183, 181, 151),
                          ),
                        ),
                        child: const Text("Number of times",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          mystate(() {
                            if (habitGoalEdit == 2) {
                              habitGoalEdit = 0;
                              habitBox.getAt(index)!.duration = 0;
                            } else {
                              duration = 1;
                              habitGoalEdit = 2;
                              habitBox.getAt(index)!.amount = 1;
                            }
                          });
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width * 0.43, 45)),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            habitGoalEdit == 2
                                ? const Color.fromARGB(255, 107, 138, 122)
                                : const Color.fromARGB(255, 183, 181, 151),
                          ),
                        ),
                        child: const Text("Duration",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: habitGoalEdit == 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: [
                        Center(
                          child: NumberPicker(
                            value: amount,
                            minValue: 2,
                            maxValue: 100,
                            haptics: true,
                            axis: Axis.horizontal,
                            onChanged: (value) => mystate(() => amount = value),
                          ),
                        ),
                        Center(
                          child:
                              Text("$amount ${amountNameControllerEdit.text}"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            LowerCaseTextInputFormatter(),
                          ],
                          validator: validateText,
                          controller: amountNameControllerEdit,
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(255, 183, 181, 151),
                              label: Text("Amount Name")),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: habitGoalEdit == 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: [
                        Center(
                          child: NumberPicker(
                            value: duration,
                            minValue: 1,
                            maxValue: 100,
                            haptics: true,
                            axis: Axis.horizontal,
                            onChanged: (value) =>
                                mystate(() => duration = value),
                          ),
                        ),
                        Center(
                          child: Text(
                              duration == 1 ? "1 minute" : "$duration minutes"),
                        ),
                      ],
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
