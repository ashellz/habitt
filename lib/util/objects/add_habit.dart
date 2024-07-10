import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/add_habit_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/icons_page.dart';
import 'package:habit_tracker/util/functions/validate_text.dart';
import 'package:numberpicker/numberpicker.dart';

Widget addHabit(formKey, validateText, createNewTask) {
  if (amountNameController.text.isEmpty) {
    amountNameController.text = "times";
  }
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) {
      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 25.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    "New Habit",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(35),
                    ],
                    validator: validateText,
                    controller: createcontroller,
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
                              }));
                        },
                        icon: updatedIcon,
                      ),
                      labelStyle: const TextStyle(fontSize: 16.0),
                      labelText: "Habit Name",
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
                      hint: const Text("Any Time"),
                      items: dropdownItems,
                      onChanged: (String? newValue) {
                        dropDownValue = newValue!;
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Habit goal",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
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
                              currentAmountValue = 2;
                              habitGoal = 1;
                            }
                          });
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width * 0.42, 45)),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            habitGoal == 1
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
                            if (habitGoal == 2) {
                              habitGoal = 0;
                            } else {
                              currentDurationValue = 1;
                              habitGoal = 2;
                            }
                          });
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width * 0.43, 45)),
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
                            value: currentAmountValue,
                            minValue: 2,
                            maxValue: 100,
                            haptics: true,
                            axis: Axis.horizontal,
                            onChanged: (value) =>
                                mystate(() => currentAmountValue = value),
                          ),
                        ),
                        Center(
                          child: Text(
                              "$currentAmountValue ${amountNameController.text}"),
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
                            value: currentDurationValue,
                            minValue: 1,
                            maxValue: 100,
                            haptics: true,
                            axis: Axis.horizontal,
                            onChanged: (value) =>
                                mystate(() => currentDurationValue = value),
                          ),
                        ),
                        Center(
                          child: Text(currentDurationValue == 1
                              ? "1 minute"
                              : "$currentDurationValue minutes"),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                        bottom: 20.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            createNewTask();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 37, 67, 54),
                          shape: const StadiumBorder(),
                          minimumSize: const Size(120, 50),
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
