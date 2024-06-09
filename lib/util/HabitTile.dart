import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/icons.dart';
import 'package:habit_tracker/util/getIcon.dart';
import 'package:hive_flutter/hive_flutter.dart';

final habitBox = Hive.box<HabitData>('habits');
final _formKey = GlobalKey<FormState>();

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.edittask,
    required this.deletetask,
    required this.index,
    required this.checkTask,
  });

  final int index;
  final Future<void> Function(int index) deletetask;
  final void Function(int index) edittask;
  final void Function(int index) checkTask;

  void popmenu(BuildContext context) {
    Navigator.pop(context);
  }

  String? _validateText(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter some text';
    }
    return null;
  }

  String truncatedText(index) {
    if (habitBox.getAt(index)!.name.length > 18) {
      return '${habitBox.getAt(index)!.name.substring(0, 18)}...';
    }
    return habitBox.getAt(index)!.name;
  }

  @override
  Widget build(BuildContext context) {
    IconData displayIcon = getIcon(index);
    return Column(
      children: [
        const SizedBox(height: 10),
        Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.30,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => checkTask(index),
                backgroundColor: const Color.fromARGB(255, 37, 67, 54),
                foregroundColor: Colors.white,
                label: habitBox.getAt(index)!.completed ? 'Undo' : 'Done',
                borderRadius: BorderRadius.circular(15),
              ),
              const SizedBox(width: 10),
            ],
          ),
          child: GestureDetector(
            onTap: () => showModalBottomSheet(
              enableDrag: true,
              context: context,
              backgroundColor: const Color.fromARGB(255, 218, 211, 190),
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter mystate) {
                    if (!changed) {
                      updatedIcon = Icon(getIcon(index));
                    }
                    if (editcontroller.text.isEmpty) {
                      editcontroller.text = habitBox.getAt(index)!.name;
                    }
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
                                "Edit Habit",
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
                                controller: editcontroller,
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
                                            changed = true;
                                          }));
                                    },
                                    icon: updatedIcon,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 183, 181,
                                      151), // Apply background color
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
                              padding: const EdgeInsets.only(
                                  bottom: 20, right: 20, left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 152, 26, 51),
                                      shape: const StadiumBorder(),
                                      minimumSize: const Size(
                                          120, 50), // Increase button size
                                    ),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        edittask(index);
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
                    );
                  },
                );
              },
            ).whenComplete(() {
              editcontroller.clear();
              changed = false;
              updatedIcon = startIcon;
            }),
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 5.0,
              ),
              leading: Icon(
                displayIcon,
                color: habitBox.getAt(index)!.completed
                    ? Colors.grey.shade600
                    : Colors.grey.shade800,
              ),
              title: Text(
                truncatedText(index),
                style: TextStyle(
                    color: habitBox.getAt(index)!.completed
                        ? Colors.grey.shade600
                        : Colors.black,
                    decoration: habitBox.getAt(index)!.completed
                        ? TextDecoration.lineThrough
                        : null),
              ),
              trailing: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: habitBox.getAt(index)!.completed
                      ? const Color.fromARGB(255, 37, 67, 54)
                      : const Color.fromARGB(255, 183, 181, 151),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                    habitBox.getAt(index)!.completed
                        ? Icons.check
                        : Icons.close,
                    color: habitBox.getAt(index)!.completed
                        ? Colors.white
                        : Colors.grey.shade800),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
