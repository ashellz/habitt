import 'package:flutter/material.dart';
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
