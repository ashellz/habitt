import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/icons.dart';
import 'package:habit_tracker/util/HabitTile.dart';
import 'package:habit_tracker/util/getIcon.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';

Icon startIcon = const Icon(Icons.book);
Icon updatedIcon = startIcon;
final createcontroller = TextEditingController();
final editcontroller = TextEditingController();
final habitBox = Hive.box<HabitData>('habits');
final metadataBox = Hive.box<DateTime>('metadata');
late HabitData myHabit;
String dropDownValue = 'Any Time';
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
    updateLastOpenedDate();
    scheduleMidnightTask();
  }

  void scheduleMidnightTask() {
    Timer(
      Duration(
        hours: 24 - DateTime.now().hour,
        minutes: 60 - DateTime.now().minute,
        seconds: 60 - DateTime.now().second,
      ),
      () {
        updateStreaks();
        scheduleMidnightTask(); // Reschedule the task
      },
    );
  }

  void updateStreaks() {
    var habits = habitBox.values;
    for (var habit in habits) {
      if (habit.completed) {
        habit.streak += 1;
      } else {
        habit.streak = 0;
      }
      habit.completed = false;
    }
  }

  void updateLastOpenedDate() async {
    DateTime? lastOpened = metadataBox.get('lastOpenedDate');
    DateTime now = DateTime.now();

    if (lastOpened != null) {
      int daysDifference = now.difference(lastOpened).inDays;

      if (daysDifference > 0) {
        resetOrUpdateStreaks(daysDifference);
      }
    }

    metadataBox.put('lastOpenedDate', now);
  }

  void resetOrUpdateStreaks(int daysDifference) {
    var habits = habitBox.values;
    for (var habit in habits) {
      if (habit.completed) {
        habit.streak += 1;
      } else {
        habit.streak = 0;
      }
      habit.completed = false;
    }
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

  void createNewTask() {
    setState(() {
      myHabit = HabitData(
        name: createcontroller.text,
        completed: false,
        icon: getIconString(updatedIcon.icon),
        category: dropDownValue,
      );
      habitBox.add(myHabit);
      habitListLenght = habitBox.length;
      openCategory("created");
    });
    createcontroller.clear();
    updatedIcon = startIcon;
    dropDownValue = 'Any time';
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
              morningHeight += 71;
            }
          }
        } else if (key == "created") {
          morningHeight += 71;
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
              afternoonHeight += 71;
            }
          }
        } else if (key == "created") {
          afternoonHeight += 71;
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
              eveningHeight += 71;
            }
          }
        } else if (key == "created") {
          eveningHeight += 71;
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
              anyTimeHeight += 71;
            }
          }
        } else if (key == "created") {
          anyTimeHeight += 71;
        }
      });
    }
  }

  void updateHeightDelete(index) {
    setState(() {
      if (habitBox.getAt(index)!.category == "Morning") {
        morningHeight -= 71;
      } else if (habitBox.getAt(index)!.category == "Afternoon") {
        afternoonHeight -= 71;
      } else if (habitBox.getAt(index)!.category == "Evening") {
        eveningHeight -= 71;
      } else if (habitBox.getAt(index)!.category == "Any time") {
        anyTimeHeight -= 71;
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

  Future<void> deleteTask(int index) async {
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
                    "Are you sure you want to delete this task?",
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
        morningHeight -= 71;
      });
    } else if (editedFrom == "Afternoon") {
      setState(() {
        afternoonHeight -= 71;
      });
    } else if (editedFrom == "Evening") {
      setState(() {
        eveningHeight -= 71;
      });
    } else if (editedFrom == "Any time") {
      setState(() {
        anyTimeHeight -= 71;
      });
    }

    if (editedTo == "Morning") {
      setState(() {
        morningHeight += 71;
        openCategory("no");
      });
    } else if (editedTo == "Afternoon") {
      setState(() {
        afternoonHeight += 71;
        openCategory("no");
      });
    } else if (editedTo == "Evening") {
      setState(() {
        eveningHeight += 71;
        openCategory("no");
      });
    } else if (editedTo == "Any time") {
      setState(() {
        anyTimeHeight += 71;
        openCategory("no");
      });
    }
  }

  void editTask(int index) {
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
          ));
    });
    checkIfEmpty(editedFrom);
    dropDownValue = 'Any time';
    editcontroller.text = "";
    updatedIcon = startIcon;
    Navigator.pop(context);
    showPopup(context, "Habit edited!");
  }

  void checkTask(int index) {
    setState(() {
      final habitBox = Hive.box<HabitData>('habits');
      final existingHabit = habitBox.getAt(index);

      if (existingHabit != null) {
        final updatedHabit = HabitData(
          name: existingHabit.name,
          completed: !existingHabit.completed,
          icon: existingHabit.icon,
          category: existingHabit.category,
        );

        habitBox.putAt(index, updatedHabit);
      }
    });
  }

  String? _validateText(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter some text';
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
              enableDrag: true,
              context: context,
              backgroundColor: const Color.fromARGB(255, 218, 211, 190),
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter mystate) {
                    return SizedBox(
                      child: Form(
                        key: _formKey,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                validator: _validateText,
                                controller: createcontroller,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const IconsPage(),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 183, 181,
                                      151), // Added background color
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonFormField(
                                  dropdownColor:
                                      const Color.fromARGB(255, 218, 211, 190),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 218, 211, 190),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                  hint: const Text("Any Time"),
                                  items: dropdownItems,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropDownValue = newValue!;
                                    });
                                  },
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
                                      if (_formKey.currentState!.validate()) {
                                        createNewTask();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 37, 67, 54),
                                      shape: const StadiumBorder(),
                                      minimumSize: const Size(
                                          120, 50), // Increase button size
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
                    );
                  },
                );
              },
            ).whenComplete(() {
              createcontroller.clear();
              updatedIcon = startIcon;
            }),
          ),
        ],
      ),
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
                            morningHeight += 71;
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
                        edittask: editTask,
                        deletetask: deleteTask,
                        checkTask: checkTask,
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
                            afternoonHeight += 71;
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
                        edittask: editTask,
                        deletetask: deleteTask,
                        checkTask: checkTask,
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
                            eveningHeight += 71;
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
                        edittask: editTask,
                        deletetask: deleteTask,
                        checkTask: checkTask,
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
                            containerHeight += 71;
                            anyTimeHeight += 71;
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
                        edittask: editTask,
                        deletetask: deleteTask,
                        checkTask: checkTask,
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
