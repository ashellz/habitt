import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/icons.dart';
import 'package:habit_tracker/util/HabitTile.dart';
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
String dropDownValue = 'Any time';
final _formKey = GlobalKey<FormState>();

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
          icon: getIconString(updatedIcon.icon),
          category: dropDownValue);
      habitBox.add(myHabit);
      habitListLenght = habitBox.length;
    });
    dropDownValue = 'Any time';
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
            category: dropDownValue,
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
      ),
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
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
                          image:
                              AssetImage('assets/images/morning_picture.png')),
                    ),
                  )),

              /*child: Text(
                "Morning",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
            ),
            for (int i = 0; i < habitListLenght; i++)
              if (habitBox.getAt(i)?.category == 'Morning')
                HabitTile(
                  edittask: editTask,
                  deletetask: deleteTask,
                  checkTask: checkTask,
                  index: i,
                ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                "Afternoon",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (int i = 0; i < habitListLenght; i++)
              if (habitBox.getAt(i)?.category == 'Afternoon')
                HabitTile(
                  edittask: editTask,
                  deletetask: deleteTask,
                  checkTask: checkTask,
                  index: i,
                ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                "Evening",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (int i = 0; i < habitListLenght; i++)
              if (habitBox.getAt(i)?.category == 'Evening')
                HabitTile(
                  edittask: editTask,
                  deletetask: deleteTask,
                  checkTask: checkTask,
                  index: i,
                ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                "Any time",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (int i = 0; i < habitListLenght; i++)
              if (habitBox.getAt(i)?.category == 'Any time')
                HabitTile(
                  edittask: editTask,
                  deletetask: deleteTask,
                  checkTask: checkTask,
                  index: i,
                ),
          ],
        ),
      ]),
      // body: ListView.builder(
      //     itemCount: habitListLenght,
      //     itemBuilder: (context, index) => HabitTile(
      //         edittask: editTask,
      //         deletetask: deleteTask,
      //         checkTask: checkTask,
      //         index: index)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            validator: _validateText,
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
                              labelStyle: const TextStyle(fontSize: 16.0),
                              labelText: "Habit Name",
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(
                                  255, 183, 181, 151), // Added background color
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
                                fillColor:
                                    const Color.fromARGB(255, 218, 211, 190),
                              ),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                              hint: const Text("Any time"),
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Morning", child: Text("Morning")),
    const DropdownMenuItem(value: "Afternoon", child: Text("Afternoon")),
    const DropdownMenuItem(value: "Evening", child: Text("Evening")),
    const DropdownMenuItem(value: "Any time", child: Text("Any time")),
  ];
  return menuItems;
}
