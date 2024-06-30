import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/icons_page.dart';
import 'package:habit_tracker/util/functions/getIcon.dart';
import 'package:hive/hive.dart';
import 'package:numberpicker/numberpicker.dart';

final habitBox = Hive.box<HabitData>('habits');

Widget editHabit(_formKey, _validateText, deletetask, edithabit, index) {
  late int habitGoal;
  late int amountValue;
  late int durationValue;
  TextEditingController amountNameController = TextEditingController();
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) {
      if (!changed) {
        updatedIcon = Icon(getIcon(index));
      }
      if (editcontroller.text.isEmpty) {
        editcontroller.text = habitBox.getAt(index)!.name;
      }

      if (habitBox.getAt(index)!.amount > 1) {
        habitGoal = 1;
        amountValue = habitBox.getAt(index)!.amountCompleted;
        amountNameController.text = habitBox.getAt(index)!.amountName;
      } else {
        habitGoal = 2;
        durationValue = habitBox.getAt(index)!.durationCompleted;
      }

      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Form(
            key: _formKey,
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
                    validator: _validateText,
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          mystate(() {
                            if (habitGoal == 1) {
                              habitGoal = 0;
                            } else {
                              amountValue = 2;
                              habitGoal = 1;
                            }
                          });
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all<Size>(
                              const Size(170, 45)),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            habitGoal == 1
                                ? const Color.fromARGB(255, 107, 138, 122)
                                : const Color.fromARGB(255, 183, 181, 151),
                          ),
                        ),
                        child: const Text("Number of times",
                            style: TextStyle(color: Colors.black)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          mystate(() {
                            if (habitGoal == 2) {
                              habitGoal = 0;
                            } else {
                              durationValue = 1;
                              habitGoal = 2;
                            }
                          });
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all<Size>(
                              const Size(170, 45)),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            habitGoal == 2
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
                  visible: habitGoal == 1,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: [
                        Center(
                          child: NumberPicker(
                            value: amountValue,
                            minValue: 2,
                            maxValue: 100,
                            haptics: true,
                            axis: Axis.horizontal,
                            onChanged: (value) =>
                                mystate(() => amountValue = value),
                          ),
                        ),
                        Center(
                          child:
                              Text("$amountValue ${amountNameController.text}"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            LowerCaseTextInputFormatter(),
                          ],
                          controller: amountNameController,
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
                  visible: habitGoal == 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: [
                        Center(
                          child: NumberPicker(
                            value: durationValue,
                            minValue: 1,
                            maxValue: 100,
                            haptics: true,
                            axis: Axis.horizontal,
                            onChanged: (value) =>
                                mystate(() => durationValue = value),
                          ),
                        ),
                        Center(
                          child: Text(durationValue == 1
                              ? "1 minute"
                              : "$durationValue minutes"),
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
                          if (_formKey.currentState!.validate()) {
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

class LowerCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
