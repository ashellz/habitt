import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/util/objects/add_habit.dart';
import 'package:habit_tracker/util/objects/display_habit_tile.dart';
import 'package:habit_tracker/util/functions/getIcon.dart';
import 'package:habit_tracker/util/functions/updateLastOpenedDate.dart';
import 'package:habit_tracker/util/objects/edit_habit.dart';
import 'package:habit_tracker/util/objects/menu_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';

Icon startIcon = const Icon(Icons.book);
Icon updatedIcon = startIcon;
final createcontroller = TextEditingController();
final editcontroller = TextEditingController();
final habitBox = Hive.box<HabitData>('habits');
final metadataBox = Hive.box<DateTime>('metadata');
final streakBox = Hive.box<int>('streak');
final notificationsBox = Hive.box<bool>('notifications');
late HabitData myHabit;
String dropDownValue = 'Any time';
final _formKey = GlobalKey<FormState>();
bool eveningVisible = false,
    anyTimeVisible = false,
    afternoonVisible = false,
    morningVisible = false,
    changed = false,
    deleted = false;
double anyTimeHeight = 0,
    containerHeight = 0,
    eveningHeight = 0,
    afternoonHeight = 0,
    morningHeight = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key, Key? homePageKey});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool popupOpacity = true;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    if (notificationsBox.get("hasNotificationAccess") == false) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed) {
        notificationsBox.put("hasNotificationAccess", true);
      } else {
        notificationsBox.put("hasNotificationAccess", false);
      }
    });

    updateLastOpenedDate();
  }

  void showPopup(BuildContext context, String text) {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry(text);
    Overlay.of(context).insert(_overlayEntry!);

    // Initially set popupOpacity to false so it will animate into view
    Future.delayed(Duration.zero, () {
      setState(() {
        popupOpacity = false;
        _overlayEntry?.markNeedsBuild();
      });
    });
    // Delay to let the popup stay visible for a while
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        popupOpacity = true;
        _overlayEntry?.markNeedsBuild();
      });

      // Delay to allow the animation to complete before removing the popup
      Future.delayed(const Duration(milliseconds: 500), () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    });
  }

  OverlayEntry _createOverlayEntry(String text) {
    return OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.fastOutSlowIn,
            left: MediaQuery.of(context).size.width / 2 - 80,
            top: popupOpacity ? -80 : MediaQuery.of(context).padding.top + 10,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 50,
                width: 160,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 183, 181, 151),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  var habitListLenght = Hive.box<HabitData>('habits').length;

  bool isTapAllowed = true;

  void _onTapWithThrottle(VoidCallback onTap) {
    if (isTapAllowed) {
      isTapAllowed = false;
      onTap();
      Timer(const Duration(milliseconds: 500), () {
        isTapAllowed = true;
      });
    }
  }

  void createNewHabit() {
    setState(() {
      myHabit = HabitData(
        name: createcontroller.text,
        completed: false,
        icon: getIconString(updatedIcon.icon),
        category: dropDownValue,
        streak: 0,
        amount: habitGoal == 1 ? currentAmountValue : 1,
        amountName: amountNameController.text,
        amountCompleted: 0,
        duration: habitGoal == 2 ? currentDurationValue : 0,
        durationCompleted: 0,
      );
      habitBox.add(myHabit);
      habitListLenght = habitBox.length;
      openCategory("created");
    });
    createcontroller.clear();
    updatedIcon = startIcon;
    dropDownValue = 'Any time';
    amountNameController.text = "times";
    currentAmountValue = 2;
    currentDurationValue = 1;
    habitGoal = 0;
    Navigator.pop(context);
    showPopup(context, "Habit added!");
  }

  void openCategory(String key) {
    if (dropDownValue == "Morning") {
      setState(() {
        if (morningHasHabits == false) {
          morningHasHabits = true;
        }
        if (morningVisible == false) {
          morningVisible = true;
          for (int i = 0; i < habitListLenght; i++) {
            if (habitBox.getAt(i)?.category == 'Morning') {
              morningHeight += 82;
            }
          }
        } else if (key == "created") {
          morningHeight += 82;
        }
      });
    } else if (dropDownValue == "Afternoon") {
      setState(() {
        if (afternoonHasHabits == false) {
          afternoonHasHabits = true;
        }
        if (afternoonVisible == false) {
          afternoonVisible = true;
          for (int i = 0; i < habitListLenght; i++) {
            if (habitBox.getAt(i)?.category == 'Afternoon') {
              afternoonHeight += 82;
            }
          }
        } else if (key == "created") {
          afternoonHeight += 82;
        }
      });
    } else if (dropDownValue == "Evening") {
      setState(() {
        if (eveningHasHabits == false) {
          eveningHasHabits = true;
        }
        if (eveningVisible == false) {
          eveningVisible = true;
          for (int i = 0; i < habitListLenght; i++) {
            if (habitBox.getAt(i)?.category == 'Evening') {
              eveningHeight += 82;
            }
          }
        } else if (key == "created") {
          eveningHeight += 82;
        }
      });
    } else if (dropDownValue == "Any time") {
      setState(() {
        if (anytimeHasHabits == false) {
          anytimeHasHabits = true;
        }
        if (anyTimeVisible == false) {
          anyTimeVisible = true;
          for (int i = 0; i < habitListLenght; i++) {
            if (habitBox.getAt(i)?.category == 'Any time') {
              anyTimeHeight += 82;
            }
          }
        } else if (key == "created") {
          anyTimeHeight += 82;
        }
      });
    }
  }

  void updateHeightDelete(index) {
    setState(() {
      if (habitBox.getAt(index)!.category == "Morning") {
        morningHeight -= 82;
      } else if (habitBox.getAt(index)!.category == "Afternoon") {
        afternoonHeight -= 82;
      } else if (habitBox.getAt(index)!.category == "Evening") {
        eveningHeight -= 82;
      } else if (habitBox.getAt(index)!.category == "Any time") {
        anyTimeHeight -= 82;
      }
    });
  }

  String checkCategory(String category) {
    if (category == "Morning") {
      return "Morning";
    } else if (category == "Afternoon") {
      return "Afternoon";
    } else if (category == "Evening") {
      return "Evening";
    } else if (category == "Any time") {
      return "Any time";
    }
    return "";
  }

  void checkIfEmpty(String category) {
    bool hasHabits = false;
    for (int i = 0; i < habitListLenght; i++) {
      if (habitBox.getAt(i)?.category == category) {
        hasHabits = true;
        break;
      }
    }

    if (hasHabits == false) {
      setState(() {
        if (category == "Morning") {
          morningHasHabits = false;
          morningVisible = false;
        } else if (category == "Afternoon") {
          afternoonHasHabits = false;
          afternoonVisible = false;
        } else if (category == "Evening") {
          eveningHasHabits = false;
          eveningVisible = false;
        } else if (category == "Any time") {
          anytimeHasHabits = false;
          anyTimeVisible = false;
        }
      });
    }
  }

  late String category;

  Future<void> deleteHabit(int index) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 218, 211, 190),
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
                      color: Colors.black,
                      fontSize: 18,
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
                        backgroundColor: const Color.fromARGB(255, 152, 26, 51),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          category = checkCategory(
                              habitBox.getAt(index)!.category.toString());
                          updateHeightDelete(index);
                          habitBox.deleteAt(index);
                          habitListLenght = habitBox.length;
                          checkIfEmpty(category);
                        });
                        deleted = true;
                        editcontroller.text = "";
                        Navigator.of(context).pop();
                        showPopup(context, "Habit deleted!");
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
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

  late String editedFrom;
  late String editedTo;

  void editHeights() {
    if (editedFrom == "Morning") {
      setState(() {
        morningHeight -= 82;
      });
    } else if (editedFrom == "Afternoon") {
      setState(() {
        afternoonHeight -= 82;
      });
    } else if (editedFrom == "Evening") {
      setState(() {
        eveningHeight -= 82;
      });
    } else if (editedFrom == "Any time") {
      setState(() {
        anyTimeHeight -= 82;
      });
    }

    if (editedTo == "Morning") {
      setState(() {
        morningHeight += 82;
        openCategory("no");
      });
    } else if (editedTo == "Afternoon") {
      setState(() {
        afternoonHeight += 82;
        openCategory("no");
      });
    } else if (editedTo == "Evening") {
      setState(() {
        eveningHeight += 82;
        openCategory("no");
      });
    } else if (editedTo == "Any time") {
      setState(() {
        anyTimeHeight += 82;
        openCategory("no");
      });
    }
  }

  void editHabit(int index) {
    editedFrom = habitBox.getAt(index)!.category;
    editedTo = dropDownValue;
    editHeights();
    setState(() {
      habitBox.putAt(
          index,
          HabitData(
            name: editcontroller.text,
            completed: habitBox.getAt(index)?.completed ?? false,
            icon: getIconString(updatedIcon.icon),
            category: dropDownValue,
            streak: habitBox.getAt(index)?.streak ?? 0,
            amount: habitGoalEdit == 1 ? amount : habitBox.getAt(index)!.amount,
            amountName: amountNameControllerEdit.text,
            amountCompleted: 0,
            duration: habitGoalEdit == 2
                ? duration
                : habitBox.getAt(index)?.duration ?? 0,
            durationCompleted: 0,
          ));
    });
    checkIfEmpty(editedFrom);
    dropDownValue = 'Any time';
    editcontroller.text = "";
    updatedIcon = startIcon;
    Navigator.pop(context);
    showPopup(context, "Habit edited!");
  }

  void checkHabit(int index) {
    setState(() {
      final habitBox = Hive.box<HabitData>('habits');
      final existingHabit = habitBox.getAt(index);

      if (existingHabit != null) {
        final updatedHabit = HabitData(
          name: existingHabit.name,
          completed: !existingHabit.completed,
          icon: existingHabit.icon,
          category: existingHabit.category,
          streak: existingHabit.streak,
          amount: existingHabit.amount,
          amountName: existingHabit.amountName,
          amountCompleted: !existingHabit.completed ? existingHabit.amount : 0,
          duration: existingHabit.duration,
          durationCompleted:
              !existingHabit.completed ? existingHabit.duration : 0,
        );

        habitBox.putAt(index, updatedHabit);
      }
    });
  }

  String? _validateText(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter some text';
    } else if (value == null || value.trim().isEmpty) {
      return 'Input cannot be just spaces';
    }
    return null;
  }
  // THE SCAFFOLD STARTS HERE, ALL ABOVE ARE FUNCTIONS AND DECLARATIONS

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 211, 190),
      appBar: AppBar(
        title: const Text("HABIT TRACKER"),
        centerTitle: true,
        toolbarHeight: 80.0,
        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
        actions: [
          IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              backgroundColor: const Color.fromARGB(255, 218, 211, 190),
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: addHabit(_formKey, _validateText, createNewHabit),
                );
              },
            ).whenComplete(() {
              createcontroller.clear();
              updatedIcon = startIcon;
              habitGoal = 0;
              dropDownValue = 'Any time';
              amountNameController.text = "times";
              currentAmountValue = 2;
              currentDurationValue = 1;
            }),
          ),
        ],
      ),
      drawer: menuDrawer(context),
      body: ListView(
        children: [
          //Morning

          Visibility(
            visible: morningHasHabits,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: GestureDetector(
                onTap: () {
                  _onTapWithThrottle(() {
                    setState(() {
                      morningVisible = !morningVisible;

                      if (morningVisible == true) {
                        for (int i = 0; i < habitListLenght; i++) {
                          if (habitBox.getAt(i)?.category == 'Morning') {
                            morningHeight += 82;
                          }
                        }
                      } else {
                        morningHeight = 0;
                      }
                    });
                  });
                },
                child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: const GridTile(
                        footer: Center(
                            child: Text(
                          "Morning",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                        child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/images/morning_picture.png')),
                      ),
                    )),
              ),
            ),
          ),
          AnimatedContainer(
            color: const Color.fromARGB(255, 218, 211, 190),
            duration: const Duration(milliseconds: 500),
            height: morningVisible ? morningHeight : 0,
            curve: Curves.fastOutSlowIn,
            child: Column(
              children: [
                for (int i = 0; i < habitListLenght; i++)
                  if (habitBox.getAt(i)?.category == 'Morning')
                    AnimatedOpacity(
                      opacity: morningVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: HabitTile(
                        edithabit: editHabit,
                        deletehabit: deleteHabit,
                        checkHabit: checkHabit,
                        index: i,
                      ),
                    ),
              ],
            ),
          ),

          // Afternoon

          Visibility(
            visible: afternoonHasHabits,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: GestureDetector(
                onTap: () {
                  _onTapWithThrottle(() {
                    setState(() {
                      afternoonVisible = !afternoonVisible;
                      if (afternoonVisible == true) {
                        for (int i = 0; i < habitListLenght; i++) {
                          if (habitBox.getAt(i)?.category == 'Afternoon') {
                            afternoonHeight += 82;
                          }
                        }
                      } else {
                        afternoonHeight = 0;
                      }
                    });
                  });
                },
                child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: const GridTile(
                        footer: Center(
                            child: Text(
                          "Afternoon",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                        child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/images/afternoon_picture.png')),
                      ),
                    )),
              ),
            ),
          ),
          AnimatedContainer(
            color: const Color.fromARGB(255, 218, 211, 190),
            duration: const Duration(milliseconds: 500),
            height: afternoonVisible ? afternoonHeight : 0,
            curve: Curves.fastOutSlowIn,
            child: Column(
              children: [
                for (int i = 0; i < habitListLenght; i++)
                  if (habitBox.getAt(i)?.category == 'Afternoon')
                    AnimatedOpacity(
                      opacity: afternoonVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: HabitTile(
                        edithabit: editHabit,
                        deletehabit: deleteHabit,
                        checkHabit: checkHabit,
                        index: i,
                      ),
                    ),
              ],
            ),
          ),

          // Evening

          Visibility(
            visible: eveningHasHabits,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: GestureDetector(
                onTap: () {
                  _onTapWithThrottle(() {
                    setState(() {
                      eveningVisible = !eveningVisible;
                      if (eveningVisible == true) {
                        for (int i = 0; i < habitListLenght; i++) {
                          if (habitBox.getAt(i)?.category == 'Evening') {
                            eveningHeight += 82;
                          }
                        }
                      } else {
                        eveningHeight = 0;
                      }
                    });
                  });
                },
                child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: const GridTile(
                        footer: Center(
                            child: Text(
                          "Evening",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                        child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/images/evening_picture.png')),
                      ),
                    )),
              ),
            ),
          ),
          AnimatedContainer(
            color: const Color.fromARGB(255, 218, 211, 190),
            duration: const Duration(milliseconds: 500),
            height: eveningVisible ? eveningHeight : 0,
            curve: Curves.fastOutSlowIn,
            child: Column(
              children: [
                for (int i = 0; i < habitListLenght; i++)
                  if (habitBox.getAt(i)?.category == 'Evening')
                    AnimatedOpacity(
                      opacity: eveningVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: HabitTile(
                        edithabit: editHabit,
                        deletehabit: deleteHabit,
                        checkHabit: checkHabit,
                        index: i,
                      ),
                    ),
              ],
            ),
          ),

          // Any time

          Visibility(
            visible: anytimeHasHabits,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: GestureDetector(
                onTap: () {
                  _onTapWithThrottle(() {
                    setState(() {
                      anyTimeVisible = !anyTimeVisible;
                      if (anyTimeVisible == true) {
                        containerHeight = anyTimeHeight;
                        for (int i = 0; i < habitListLenght; i++) {
                          if (habitBox.getAt(i)?.category == 'Any time') {
                            containerHeight += 82;
                            anyTimeHeight += 82;
                          }
                        }
                      } else {
                        anyTimeHeight = 0;
                      }
                    });
                  });
                },
                child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: const GridTile(
                        footer: Center(
                            child: Text(
                          "Any Time",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                        child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/images/anytime_picture.png')),
                      ),
                    )),
              ),
            ),
          ),
          AnimatedContainer(
            color: const Color.fromARGB(255, 218, 211, 190),
            duration: const Duration(milliseconds: 500),
            height: anyTimeVisible ? anyTimeHeight : 0,
            curve: Curves.fastOutSlowIn,
            child: Column(
              children: [
                for (int i = 0; i < habitListLenght; i++)
                  if (habitBox.getAt(i)?.category == 'Any time')
                    AnimatedOpacity(
                      opacity: anyTimeVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: HabitTile(
                        edithabit: editHabit,
                        deletehabit: deleteHabit,
                        checkHabit: checkHabit,
                        index: i,
                      ),
                    ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: containerHeight,
            color: const Color.fromARGB(255, 218, 211, 190),
          )
        ],
      ),
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Morning", child: Text("Morning")),
    const DropdownMenuItem(value: "Afternoon", child: Text("Afternoon")),
    const DropdownMenuItem(value: "Evening", child: Text("Evening")),
    const DropdownMenuItem(value: "Any time", child: Text("Any Time")),
  ];
  return menuItems;
}
