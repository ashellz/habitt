import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_spinbox/material.dart";
import "package:habit_tracker/pages/habit/icons_page.dart";
import "package:habit_tracker/pages/habit/notifications_page.dart";
import "package:habit_tracker/pages/new_home_page.dart";
import "package:habit_tracker/services/provider/habit_provider.dart";
import "package:habit_tracker/util/colors.dart";
import "package:habit_tracker/util/functions/checkForNotifications.dart";
import "package:habit_tracker/util/functions/habit/getIcon.dart";
import "package:habit_tracker/util/functions/validate_text.dart";
import "package:habit_tracker/util/objects/habit/add_tag.dart";
import "package:habit_tracker/util/objects/habit/confirm_delete_habit.dart";
import "package:habit_tracker/util/objects/habit/delete_tag.dart";
import "package:provider/provider.dart";
import 'package:icons_flutter/icons_flutter.dart';
import "package:vibration/vibration.dart";

int habitGoalEdit = 0;
late int amount;
late int duration;
late int durationHours;
late int durationMinutes;

bool updated = false;
bool dropDownChanged = false;

TextEditingController amountNameControllerEdit = TextEditingController();
TextEditingController amountControllerEdit = TextEditingController();

final formKey = GlobalKey<FormState>();

class EditHabitPage extends StatefulWidget {
  const EditHabitPage({
    super.key,
    required this.index,
    required this.editcontroller,
  });

  final int index;
  final TextEditingController editcontroller;

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
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
    final editcontroller = widget.editcontroller;
    final desccontroller = context.watch<HabitProvider>().notescontroller;

    if (!changed) {
      updatedIcon = Icon(getIcon(widget.index));
    }

    if (!updated) {
      if (habitBox.getAt(widget.index)!.amount > 1) {
        habitGoalEdit = 1;
        amount = habitBox.getAt(widget.index)!.amount;
        amountNameControllerEdit.text =
            habitBox.getAt(widget.index)!.amountName;
        duration = 0;
        durationHours = 0;
        durationMinutes = 0;
      } else if (habitBox.getAt(widget.index)!.duration > 0) {
        habitGoalEdit = 2;
        duration = habitBox.getAt(widget.index)!.duration;
        amount = 1;
        durationHours = duration ~/ 60;
        durationMinutes = duration % 60;
      } else {
        habitGoalEdit = 0;
        amount = 1;
        duration = 0;
        durationHours = 0;
        durationMinutes = 0;
      }

      if (editcontroller.text.isEmpty) {
        editcontroller.text = habitBox.getAt(widget.index)!.name;
      }

      if (amountNameControllerEdit.text.isEmpty) {
        amountNameControllerEdit.text = "times";
      }

      amountControllerEdit.text = amount.toString();

      habitTag = habitBox.getAt(widget.index)!.tag;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HabitProvider>().changeNotification(
            List.from(habitBox.getAt(widget.index)!.notifications));
      });

      context.watch<HabitProvider>().notescontroller.text =
          habitBox.getAt(widget.index)!.notes;

      updated = true;
    }

    if (!dropDownChanged) {
      dropDownValue = habitBox.getAt(widget.index)!.category;
    }

    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, actions: [
        Row(
          children: [
            const Icon(MaterialCommunityIcons.fire),
            const SizedBox(width: 3),
            Transform.translate(
              offset: const Offset(0, 1),
              child: Text(
                "${habitBox.getAt(widget.index)!.completed ? habitBox.getAt(widget.index)!.streak + 1 : habitBox.getAt(widget.index)!.streak.toString()}",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
      ]),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
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
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const NotificationsPage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(0.0, 1.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ).whenComplete(() => checkForNotifications());
                                },
                                icon: const Icon(
                                  Icons.notifications,
                                  size: 30,
                                  color: Colors.white,
                                )),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => confirmDeleteHabit(
                                          widget.index, editcontroller)).then(
                                      (value) {
                                    if (deleted) {
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.white,
                                )),
                          ],
                        ),
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
                        color: theColor,
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
                                  truncatedText(context, editcontroller),
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
                                    habitGoalNumber(),
                                    Visibility(
                                      visible: habitGoalEdit == 1,
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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                                        if (habitTag ==
                                            tempHabitTag.toString()) {
                                          habitTag = "No tag";
                                        } else {
                                          habitTag = habitTag;
                                        }
                                      });
                                    });
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: habitTag == tagBox.getAt(i)!.tag
                                          ? theColor
                                          : theDarkGrey,
                                    ),
                                    height: 30,
                                    child: Center(
                                        child: Text(tagBox.getAt(i)!.tag))),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                enableDrag: true,
                                builder: (context) => const AddTagWidget(),
                              ),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                        fillColor: theColor,
                        label: Text(
                          "Habit Name",
                          style: TextStyle(color: theLightColor),
                        ),
                      ),
                    ),
                  ),

                  //NOTES

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 15),
                    child: TextFormField(
                      onChanged: (newValue) => setState(() {
                        desccontroller.text = newValue;
                      }),
                      controller: desccontroller,
                      maxLines: 5,
                      cursorColor: Colors.white,
                      cursorWidth: 2.0,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        suffixIcon: const Icon(
                          Icons.notes_rounded,
                          color: Colors.white,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        fillColor: theColor,
                        label: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Notes",
                              style: TextStyle(color: theLightColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //DROPDOWN MENU

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
                                  chooseTime(_toggleExpansion, "Afternoon",
                                      _isVisible),
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
                              color: theColor,
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

                  // HABIT GOAL
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 5),
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
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            fixedSize: WidgetStateProperty.all<Size>(Size(
                                MediaQuery.of(context).size.width * 0.42, 50)),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              habitGoalEdit == 1
                                  ? const Color.fromARGB(255, 107, 138, 122)
                                  : theColor,
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
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            fixedSize: WidgetStateProperty.all<Size>(Size(
                                MediaQuery.of(context).size.width * 0.43, 50)),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              habitGoalEdit == 2
                                  ? const Color.fromARGB(255, 107, 138, 122)
                                  : theColor,
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Column(
                        children: [
                          SpinBox(
                            cursorColor: Colors.white,
                            iconColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              filled: true,
                              fillColor: theColor,
                              label: const Text(
                                "Amount",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            min: 2,
                            max: 9999,
                            value: amount.toDouble(),
                            onChanged: (value) {
                              Vibration.vibrate(duration: 10);
                              setState(() => amount = value.toInt());
                            },
                          ),
                          const SizedBox(
                            height: 15,
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
                              fillColor: theColor,
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
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Column(
                        children: [
                          SpinBox(
                            iconColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              filled: true,
                              fillColor: theColor,
                              label: const Text(
                                "Hours",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            min: 0,
                            max: 23,
                            value: durationHours.toDouble(),
                            onChanged: (value) {
                              Vibration.vibrate(duration: 10);
                              setState(() => durationHours = value.toInt());
                            },
                          ),
                          const SizedBox(height: 15),
                          SpinBox(
                            iconColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              filled: true,
                              fillColor: theColor,
                              label: const Text(
                                "Minutes",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            min: 0,
                            max: 59,
                            value: durationMinutes.toDouble(),
                            onChanged: (value) {
                              Vibration.vibrate(duration: 10);
                              setState(() => durationMinutes = value.toInt());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
            Transform.translate(
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
                      Provider.of<HabitProvider>(context, listen: false)
                          .editHabitProvider(
                              widget.index, context, editcontroller);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

Widget habitGoalNumber() {
  if (habitGoalEdit == 0) {
    return Container();
  } else if (habitGoalEdit == 1) {
    return Text(
      amount.toString(),
      style: const TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
  } else {
    return Column(
      children: [
        Visibility(
          visible: durationHours != 0,
          child: Text(
            "${durationHours}h",
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          visible: durationMinutes != 0,
          child: Text(
            "${durationMinutes}m",
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
            dropDownChanged = true;
            _toggleExpansion();
          },
          child: Text(
            category,
            style: const TextStyle(fontSize: 16),
          )),
    ),
  );
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

String truncatedText(BuildContext context, editcontroller) {
  double screenWidth = MediaQuery.of(context).size.width;
  int maxLength;

  if (screenWidth < 300) {
    if (habitGoalEdit == 0) {
      maxLength = 12;
    } else {
      maxLength = 8;
    } // very small screen
  } else if (screenWidth < 400) {
    if (habitGoalEdit == 0) {
      maxLength = 14;
    } else {
      maxLength = 10;
    } // small screen
  } else if (screenWidth < 500) {
    if (habitGoalEdit == 0) {
      maxLength = 19;
    } else {
      maxLength = 15;
    } // medium screen
  } else if (screenWidth < 600) {
    if (habitGoalEdit == 0) {
      maxLength = 24;
    } else {
      maxLength = 20;
    } // larger screen
  } else if (screenWidth < 650) {
    if (habitGoalEdit == 0) {
      maxLength = 30;
    } else {
      maxLength = 24;
    } // very large screen
  } else if (screenWidth < 750) {
    if (habitGoalEdit == 0) {
      maxLength = 35;
    } else {
      maxLength = 28;
    } // very very large screen
  } else {
    maxLength = 35; // tablet
  }

  String name = editcontroller.text;
  if (name.length > maxLength) {
    return '${name.substring(0, maxLength)}...';
  }
  return name;
}
