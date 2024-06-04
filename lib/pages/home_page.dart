import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Icon startIcon = const Icon(Icons.book);
Icon updatedIcon = startIcon;
final createcontroller = TextEditingController();
final editcontroller = TextEditingController();
bool deleted = false;
bool changed = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List habitList = [
    ["Add a new task", false, Icons.add],
    ["Open the app", true, Icons.door_front_door],
  ];

  void createNewTask() {
    setState(() {
      habitList.add([createcontroller.text, false, updatedIcon.icon]);
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
                          habitList.removeAt(index);
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
      habitList[index][0] = editcontroller.text;
      habitList[index][1] = false;
      habitList[index][2] = updatedIcon.icon;
    });
    editcontroller.text = "";
    updatedIcon = startIcon;
    Navigator.pop(context);
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
          itemCount: habitList.length,
          itemBuilder: (context, index) => HabitTile(
              habitList: habitList,
              edittask: editTask,
              deletetask: deleteTask,
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 200.0,
                          left: 220.0,
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
    required this.habitList,
    required this.edittask,
    required this.deletetask,
    required this.index,
  });

  final List habitList;
  final int index;
  final Future<void> Function(int index) deletetask;
  final void Function(int index) edittask;

  void popmenu(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.30,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => deletetask(index),
                backgroundColor: const Color.fromARGB(255, 37, 67, 54),
                foregroundColor: Colors.white,
                label: 'Done',
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
                      updatedIcon = Icon(habitList[index][2]);
                    }
                    if (editcontroller.text.isEmpty) {
                      editcontroller.text = habitList[index][0];
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
                          Padding(
                            padding: const EdgeInsets.only(top: 200),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                const SizedBox(
                                  width: 75,
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
              leading: Icon(habitList[index][2]),
              title: Text(habitList[index][0]),
              trailing:
                  Icon(habitList[index][1] ? Icons.check_box : Icons.close),
            ),
          ),
        ),
      ],
    );
  }
}
