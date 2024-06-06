import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/util/getIcon.dart';
import 'package:hive_flutter/hive_flutter.dart';

Icon startIcon = const Icon(Icons.book);
Icon updatedIcon = startIcon;
final createcontroller = TextEditingController();
final editcontroller = TextEditingController();
bool deleted = false;
bool changed = false;
final habitBox = Hive.box<HabitData>('habits');
late HabitData myHabit;

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var habitListLenght = Hive.box<HabitData>('habits').length;

  void createNewTask() {
    setState(() {
      myHabit = HabitData(
          name: createcontroller.text,
          completed: false,
          icon: getIconString(updatedIcon.icon));
      habitBox.add(myHabit);
      habitListLenght = habitBox.length;
    });
    createcontroller.clear();
    updatedIcon = startIcon;
    Navigator.pop(context);
  }

  Future<void> deleteTask(int index) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 218, 211, 190),
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
                          habitBox.deleteAt(index);
                          habitListLenght = habitBox.length;
                        });

                        deleted = true;
                        editcontroller.text = "";
                        Navigator.of(context).pop();
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

  void editTask(int index) {
    setState(() {
      habitBox.putAt(
          index,
          HabitData(
            name: editcontroller.text,
            completed: habitBox.getAt(index)?.completed ?? false,
            icon: getIconString(updatedIcon.icon),
          ));
    });
    editcontroller.text = "";
    updatedIcon = startIcon;
    Navigator.pop(context);
  }

  void checkTask(int index) {
    setState(() {
      final habitBox = Hive.box<HabitData>('habits');
      final existingHabit = habitBox.getAt(index);

      if (existingHabit != null) {
        // Toggle the completed status
        final updatedHabit = HabitData(
          name: existingHabit.name,
          completed: !existingHabit.completed, // Toggle the value
          icon: existingHabit.icon,
        );

        // Update the habit in the box
        habitBox.putAt(index, updatedHabit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 211, 190),
      appBar: AppBar(
        title: const Text("HABIT TRACKER"),
        centerTitle: true,
        toolbarHeight: 80.0,
        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
      ),
      body: ListView.builder(
          itemCount: habitListLenght,
          itemBuilder: (context, index) => HabitTile(
              edittask: editTask,
              deletetask: deleteTask,
              checkTask: checkTask,
              index: index)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
        onPressed: () => showModalBottomSheet(
          enableDrag: true,
          context: context,
          backgroundColor: const Color.fromARGB(255, 218, 211, 190),
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
                return SizedBox(
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
                        child: TextField(
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
                            labelStyle: const TextStyle(fontSize: 18.0),
                            labelText: "Habit Name",
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
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
                                createNewTask();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 37, 67, 54),
                                shape: const StadiumBorder(),
                                minimumSize:
                                    const Size(120, 50), // Increase button size
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
                );
              },
            );
          },
        ).whenComplete(() {
          createcontroller.clear();
          updatedIcon = startIcon;
        }),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

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
                            child: TextField(
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
                                labelStyle: const TextStyle(fontSize: 18.0),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, right: 20, left: 20),
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
                                    edittask(index);
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
                habitBox.getAt(index)!.name,
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
