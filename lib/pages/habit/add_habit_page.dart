import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:habit_tracker/pages/habit/icons_page.dart";
import "package:habit_tracker/pages/new_home_page.dart";
import "package:habit_tracker/services/provider/habit_provider.dart";
import 'package:habit_tracker/util/functions/validate_text.dart';
import "package:habit_tracker/util/objects/add_tag.dart";
import "package:habit_tracker/util/objects/delete_tag.dart";
import "package:provider/provider.dart";
import 'package:flutter_spinbox/material.dart';

int habitGoal = 0;
int currentAmountValue = 2;
int currentDurationValueHours = 0;
int currentDurationValueMinutes = 0;
int currentDurationValue = 0;

TextEditingController amountNameController = TextEditingController();
TextEditingController amountController = TextEditingController();

final formKey = GlobalKey<FormState>();

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key, required this.createcontroller});

  final TextEditingController createcontroller;

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  bool _isExpanded = false;
  bool _isVisible = false;
  bool _isGestureEnabled = true;

  void _toggleExpansion() {
    if (_isGestureEnabled) {
      setState(() {
        _isGestureEnabled = false;
      });

      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              _isVisible = true;
            });
          });
        } else {
          _isVisible = false;
        }
      });

      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _isGestureEnabled = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var createcontroller = widget.createcontroller;
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
                              truncatedText(context, createcontroller),
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
                                habitGoalNumber(),
                                Visibility(
                                  visible: habitGoal == 1,
                                  child: Text(
                                    habitGoalText(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
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

              //TAG

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: SizedBox(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (int i = 0; i < tagBox.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              habitTag = tagBox.getAt(i)!.tag;
                            }),
                            onLongPress: () {
                              String? tempHabitTag = tagBox.getAt(i)!.tag;
                              if (tagBox.getAt(i)!.tag != "No tag") {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      deleteTagWidget(i, context),
                                ).then((value) {
                                  setState(() {
                                    if (habitTag == tempHabitTag.toString()) {
                                      habitTag = "No tag";
                                    } else {
                                      habitTag = habitTag;
                                    }
                                  });
                                });
                              }
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: habitTag == tagBox.getAt(i)!.tag
                                      ? theGreen
                                      : theDarkGrey,
                                ),
                                height: 30,
                                child:
                                    Center(child: Text(tagBox.getAt(i)!.tag))),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            enableDrag: true,
                            builder: (context) => const AddTagWidget(),
                          ),
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: theDarkGrey,
                              ),
                              height: 30,
                              child: const Center(child: Text("+"))),
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

              Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: AnimatedContainer(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(192, 62, 80, 71),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.fastOutSlowIn,
                        height: _isExpanded ? 230.0 : 0.0,
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 52),
                              chooseTime(
                                  _toggleExpansion, "Any time", _isVisible),
                              chooseTime(
                                  _toggleExpansion, "Morning", _isVisible),
                              chooseTime(
                                  _toggleExpansion, "Afternoon", _isVisible),
                              chooseTime(
                                  _toggleExpansion, "Evening", _isVisible),
                            ])),
                  ),
                  GestureDetector(
                    onTap: _isGestureEnabled ? _toggleExpansion : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: theGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              dropDownValue,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Icon(
                                _isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              /*
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
              ),*/

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
                            borderRadius: BorderRadius.circular(20.0),
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
                            currentDurationValueHours = 0;
                            currentDurationValueMinutes = 0;
                            habitGoal = 2;
                          }
                        });
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
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
                      SpinBox(
                        cursorColor: Colors.white,
                        iconColor: WidgetStateProperty.all<Color>(Colors.white),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          filled: true,
                          fillColor: theGreen,
                          label: const Text(
                            "Amount",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        min: 2,
                        max: 9999,
                        value: currentAmountValue.toDouble(),
                        onChanged: (value) =>
                            setState(() => currentAmountValue = value.toInt()),
                      ),
                      const SizedBox(
                        height: 15,
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
                      SpinBox(
                        iconColor: WidgetStateProperty.all<Color>(Colors.white),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          filled: true,
                          fillColor: theGreen,
                          label: const Text(
                            "Hours",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        min: 0,
                        max: 23,
                        value: currentDurationValueHours.toDouble(),
                        onChanged: (value) => setState(
                            () => currentDurationValueHours = value.toInt()),
                      ),
                      const SizedBox(height: 15),
                      SpinBox(
                        iconColor: WidgetStateProperty.all<Color>(Colors.white),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          filled: true,
                          fillColor: theGreen,
                          label: const Text(
                            "Minutes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        min: 0,
                        max: 59,
                        value: currentDurationValueMinutes.toDouble(),
                        onChanged: (value) => setState(
                            () => currentDurationValueMinutes = value.toInt()),
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
                context
                    .read<HabitProvider>()
                    .createNewHabitProvider(createcontroller);
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget chooseTime(Function _toggleExpansion, String category, bool _isVisible) {
  return AnimatedOpacity(
    opacity: _isVisible ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 200),
    curve: Curves.fastOutSlowIn,
    child: Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 20),
      child: GestureDetector(
          onTap: () {
            dropDownValue = category;
            _toggleExpansion();
          },
          child: Text(
            category,
            style: const TextStyle(fontSize: 16),
          )),
    ),
  );
}

Widget habitGoalNumber() {
  if (habitGoal == 0) {
    return Container();
  } else if (habitGoal == 1) {
    return Text(
      currentAmountValue.toString(),
      style: const TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
  } else {
    return Column(
      children: [
        Visibility(
          visible: currentDurationValueHours != 0,
          child: Text(
            "${currentDurationValueHours}h",
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          visible: currentDurationValueMinutes != 0,
          child: Text(
            "${currentDurationValueMinutes}m",
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

String habitGoalText() {
  if (habitGoal == 0) {
    return "";
  } else if (habitGoal == 1) {
    return amountNameController.text;
  } else {
    return "";
  }
}

String truncatedText(BuildContext context, createcontroller) {
  double screenWidth = MediaQuery.of(context).size.width;
  int maxLength;

  if (screenWidth < 300) {
    if (habitGoal == 0) {
      maxLength = 12;
    } else {
      maxLength = 8;
    } // very small screen
  } else if (screenWidth < 400) {
    if (habitGoal == 0) {
      maxLength = 14;
    } else {
      maxLength = 10;
    } // small screen
  } else if (screenWidth < 500) {
    if (habitGoal == 0) {
      maxLength = 19;
    } else {
      maxLength = 15;
    } // medium screen
  } else if (screenWidth < 600) {
    if (habitGoal == 0) {
      maxLength = 24;
    } else {
      maxLength = 20;
    } // larger screen
  } else if (screenWidth < 650) {
    if (habitGoal == 0) {
      maxLength = 30;
    } else {
      maxLength = 24;
    } // very large screen
  } else if (screenWidth < 750) {
    if (habitGoal == 0) {
      maxLength = 35;
    } else {
      maxLength = 28;
    } // very very large screen
  } else {
    maxLength = 35; // tablet
  }

  String name = createcontroller.text;
  if (name.length > maxLength) {
    return '${name.substring(0, maxLength)}...';
  }
  return name;
}
