import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:habit_tracker/pages/add_habit_page.dart";
import "package:habit_tracker/pages/home_page.dart";
import "package:habit_tracker/pages/icons_page.dart";
import "package:habit_tracker/util/functions/habit/deleteHabit.dart";
import "package:habit_tracker/util/functions/habit/editHabit.dart";
import "package:habit_tracker/util/functions/habit/getIcon.dart";
import "package:habit_tracker/util/functions/validate_text.dart";
import "package:numberpicker/numberpicker.dart";

int habitGoalEdit = 0;
late int amount;
late int duration;
bool updated = false;
TextEditingController amountNameControllerEdit = TextEditingController();
bool dropDownChanged = false;

final formKey = GlobalKey<FormState>();

class EditHabitPage extends StatefulWidget {
  const EditHabitPage(
      {super.key,
      required this.index,
      required this.deletehabit,
      required this.edithabit});

  final int index;
  final Future<void> Function(int index) deletehabit;
  final void Function(int index) edithabit;

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  @override
  Widget build(BuildContext context) {
    if (!changed) {
      updatedIcon = Icon(getIcon(widget.index));
    }

    if (!updated) {
      if (habitBox.getAt(widget.index)!.amount > 1) {
        habitGoalEdit = 1;
        amount = habitBox.getAt(widget.index)!.amount;
        amountNameControllerEdit.text =
            habitBox.getAt(widget.index)!.amountName;
        duration = 1;
      } else if (habitBox.getAt(widget.index)!.duration > 0) {
        habitGoalEdit = 2;
        duration = habitBox.getAt(widget.index)!.duration == 0
            ? 1
            : habitBox.getAt(widget.index)!.duration;
        amount = habitBox.getAt(widget.index)!.amount == 1
            ? 2
            : habitBox.getAt(widget.index)!.amount;
      } else {
        habitGoalEdit = 0;
        amount = 2;
        duration = 1;
      }

      if (editcontroller.text.isEmpty) {
        editcontroller.text = habitBox.getAt(widget.index)!.name;
      }

      if (amountNameControllerEdit.text.isEmpty) {
        amountNameControllerEdit.text = "times";
      }
      updated = true;
    }

    if (!dropDownChanged) {
      dropDownValue = habitBox.getAt(widget.index)!.category;
    }

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: ListView(
            padding: const EdgeInsets.only(bottom: 60),
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        fontSize: 32.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, top: 5),
                    child: IconButton(
                        onPressed: () {
                          deleteHabit(widget.index, context);
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),

              // HABIT DISPLAY
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    color: theLightGreen,
                  ),
                  child: Row(
                    children: [
                      // ICON
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          iconSize: 80,
                          onPressed: () => Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => const IconsPage()))
                              .then((value) => setState(() {
                                    updatedIcon = theIcon;
                                  })),
                          icon: updatedIcon,
                          color: Colors.white,
                        ),
                      ),

                      //TEXT
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              truncatedText(context),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dropDownValue,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: habitGoalEdit == 0 ? 0 : 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  habitGoalNumber(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  habitGoalText(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //NAME

              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 20, bottom: 15),
                child: TextFormField(
                  onChanged: (newValue) => setState(() {
                    editcontroller.text = newValue;
                  }),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(35),
                  ],
                  validator: validateText,
                  controller: editcontroller,
                  cursorColor: Colors.white,
                  cursorWidth: 2.0,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IconsPage(),
                          ),
                        ).then((value) => setState(() {
                              updatedIcon = theIcon;
                            }));
                      },
                      icon: updatedIcon,
                      color: Colors.white,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    filled: true,
                    fillColor: theLightGreen,
                    label: const Text(
                      "Habit Name",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              //DROPDOWN MENU
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    dropdownColor: theLightGreen,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      fillColor: theLightGreen,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    hint: const Text("Any Time",
                        style: TextStyle(color: Colors.white)),
                    items: dropdownItems,
                    value: habitBox.getAt(widget.index)!.category,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownChanged = true;
                        dropDownValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              // HABIT GOAL
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (habitGoalEdit == 1) {
                            habitGoalEdit = 0;
                            habitBox.getAt(widget.index)!.amount = 1;
                          } else {
                            amount = 2;
                            habitGoalEdit = 1;
                            habitBox.getAt(widget.index)!.duration = 0;
                          }
                        });
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        fixedSize: WidgetStateProperty.all<Size>(
                            Size(MediaQuery.of(context).size.width * 0.42, 50)),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          habitGoalEdit == 1
                              ? const Color.fromARGB(255, 107, 138, 122)
                              : theLightGreen,
                        ),
                      ),
                      child: const Text("Number of times",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (habitGoalEdit == 2) {
                            habitGoalEdit = 0;
                            habitBox.getAt(widget.index)!.duration = 0;
                          } else {
                            duration = 1;
                            habitGoalEdit = 2;
                            habitBox.getAt(widget.index)!.amount = 1;
                          }
                        });
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        fixedSize: WidgetStateProperty.all<Size>(
                            Size(MediaQuery.of(context).size.width * 0.43, 50)),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          habitGoalEdit == 2
                              ? const Color.fromARGB(255, 107, 138, 122)
                              : theLightGreen,
                        ),
                      ),
                      child: const Text("Duration",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: habitGoalEdit == 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: [
                      Center(
                        child: NumberPicker(
                          value: amount,
                          minValue: 2,
                          maxValue: 100,
                          haptics: true,
                          axis: Axis.horizontal,
                          onChanged: (value) => setState(() => amount = value),
                          textStyle: const TextStyle(color: Colors.white),
                          selectedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                      Center(
                        child: Text(
                          "$amount ${amountNameControllerEdit.text}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (newValue) => setState(() {
                          amountNameControllerEdit.text = newValue;
                        }),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(35),
                        ],
                        validator: validateText,
                        controller: amountNameControllerEdit,
                        cursorColor: Colors.white,
                        cursorWidth: 2.0,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          filled: true,
                          fillColor: theLightGreen,
                          label: const Text(
                            "Amount Name",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: habitGoalEdit == 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: [
                      Center(
                        child: NumberPicker(
                          value: duration,
                          minValue: 1,
                          maxValue: 90,
                          haptics: true,
                          axis: Axis.horizontal,
                          onChanged: (value) =>
                              setState(() => duration = value),
                          textStyle: const TextStyle(color: Colors.white),
                          selectedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                      Center(
                        child: Text(
                          currentDurationValue == 1
                              ? "1 minute"
                              : "$duration minutes",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
      bottomSheet: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theButtonGreen,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          ),
          child:
              const Text('Save Changes', style: TextStyle(color: Colors.white)),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              editHabit(widget.index, context);

              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              }
            }
          },
        ),
      ),
    ));
  }
}

String habitGoalNumber() {
  if (habitGoalEdit == 0) {
    return "";
  } else if (habitGoalEdit == 1) {
    return "$amount";
  } else {
    return "$duration";
  }
}

String habitGoalText() {
  if (habitGoalEdit == 0) {
    return "";
  } else if (habitGoalEdit == 1) {
    return amountNameControllerEdit.text;
  } else {
    return habitGoalNumber() == "1" ? "minute" : "minutes";
  }
}

String truncatedText(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  int maxLength;

  if (screenWidth < 300) {
    maxLength = 8; // very small screen
  } else if (screenWidth < 400) {
    maxLength = 12; // small screen
  } else if (screenWidth < 500) {
    maxLength = 15; // medium screen
  } else {
    maxLength = 24; // larger screen
  }

  String name = editcontroller.text;
  if (name.length > maxLength) {
    return '${name.substring(0, maxLength)}...';
  }
  return name;
}
