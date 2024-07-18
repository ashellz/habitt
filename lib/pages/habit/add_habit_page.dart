import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:habit_tracker/pages/home_page.dart";
import "package:habit_tracker/pages/habit/icons_page.dart";
import "package:habit_tracker/util/functions/habit/createNewHabit.dart";
import "package:numberpicker/numberpicker.dart";
import 'package:habit_tracker/util/functions/validate_text.dart';

int habitGoal = 0;
int currentAmountValue = 2;
int currentDurationValue = 1;

TextEditingController amountNameController = TextEditingController();

final formKey = GlobalKey<FormState>();

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 60),
            physics: const BouncingScrollPhysics(),
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
                    fontSize: 32.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // ICON
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    color: theGreen,
                  ),
                  child: Row(
                    children: [
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
                        flex: habitGoal == 0 ? 0 : 1,
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
                    createcontroller.text = newValue;
                  }),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(35),
                  ],
                  validator: validateText,
                  controller: createcontroller,
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
                    fillColor: theGreen,
                    label: const Text(
                      "Habit Name",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // DROPDOWN MENU
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    dropdownColor: theGreen,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      fillColor: theGreen,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    hint: const Text("Any Time",
                        style: TextStyle(color: Colors.white)),
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      setState(() {
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
                          if (habitGoal == 1) {
                            habitGoal = 0;
                          } else {
                            currentAmountValue = 2;
                            habitGoal = 1;
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
                          habitGoal == 1
                              ? const Color.fromARGB(255, 107, 138, 122)
                              : theGreen,
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
                          if (habitGoal == 2) {
                            habitGoal = 0;
                          } else {
                            currentDurationValue = 1;
                            habitGoal = 2;
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
                          habitGoal == 2
                              ? const Color.fromARGB(255, 107, 138, 122)
                              : theGreen,
                        ),
                      ),
                      child: const Text("Duration",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: habitGoal == 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: [
                      Center(
                        child: NumberPicker(
                          value: currentAmountValue,
                          minValue: 2,
                          maxValue: 90,
                          haptics: true,
                          axis: Axis.horizontal,
                          onChanged: (value) =>
                              setState(() => currentAmountValue = value),
                          textStyle: const TextStyle(color: Colors.white),
                          selectedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                      Center(
                        child: Text(
                          "$currentAmountValue ${amountNameController.text}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (newValue) => setState(() {
                          amountNameController.text = newValue;
                        }),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(35),
                        ],
                        validator: validateText,
                        controller: amountNameController,
                        cursorColor: Colors.white,
                        cursorWidth: 2.0,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          filled: true,
                          fillColor: theGreen,
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
                visible: habitGoal == 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: [
                      Center(
                        child: NumberPicker(
                          value: currentDurationValue,
                          minValue: 1,
                          maxValue: 90,
                          haptics: true,
                          axis: Axis.horizontal,
                          onChanged: (value) =>
                              setState(() => currentDurationValue = value),
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
                              : "$currentDurationValue minutes",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theLightGreen,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
            ),
            child:
                const Text('Add Habit', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                createNewHabit();
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );
  }
}

String habitGoalNumber() {
  if (habitGoal == 0) {
    return "";
  } else if (habitGoal == 1) {
    return "$currentAmountValue";
  } else {
    return "$currentDurationValue";
  }
}

String habitGoalText() {
  if (habitGoal == 0) {
    return "";
  } else if (habitGoal == 1) {
    return amountNameController.text;
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

  String name = createcontroller.text;
  if (name.length > maxLength) {
    return '${name.substring(0, maxLength)}...';
  }
  return name;
}
