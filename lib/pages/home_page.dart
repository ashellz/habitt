import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Icon startIcon = const Icon(Icons.book);
Icon updatedIcon = startIcon;
final createcontroller = TextEditingController();
final editcontroller = TextEditingController();

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
          backgroundColor: Color.fromARGB(255, 37, 67, 54),
          content: Container(
            height: 122,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Are you sure you want to delete this task?",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text("Delete"),
                      onPressed: () {
                        setState(() {
                          habitList.removeAt(index);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      child: Text("Cancel"),
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
        itemBuilder: (context, index) => Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.35,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => deleteTask(index),
                backgroundColor: const Color.fromARGB(255, 183, 181, 151),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: HabitTile(habitList: habitList, index: index, edittask: editTask),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
        onPressed: () => showModalBottomSheet(
          enableDrag: true,
          context: context,
          backgroundColor: const Color.fromARGB(255, 218, 211, 190),
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
                return Container(
                  height: MediaQuery.of(context).size.height * 1.5 / 3,
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
                          left: 250.0,
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
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class HabitTile extends StatelessWidget {
  HabitTile({
    super.key,
    required this.habitList,
    required this.edittask,
    required this.index,
  });

  final List habitList;
  final int index;
  final void Function(int index) edittask;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => showModalBottomSheet(
            enableDrag: true,
            context: context,
            backgroundColor: const Color.fromARGB(255, 218, 211, 190),
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter mystate) {
                  if (editcontroller.text.isEmpty) {
                    editcontroller.text = habitList[index][0];
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height * 1.5 / 3,
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          padding: const EdgeInsets.only(
                            top: 200.0,
                            left: 250.0,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              edittask(index);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 37, 67, 54),
                              shape: const StadiumBorder(),
                              minimumSize:
                                  const Size(120, 50), // Increase button size
                            ),
                            child: const Text(
                              "Save",
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
          ),
        child: ListTile(
          contentPadding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 5.0,
          ),
          leading: Icon(habitList[index][2]),
          title: Text(habitList[index][0]),
          trailing: Icon(habitList[index][1] ? Icons.check_box : Icons.close),
        ),
      );
  }
}
