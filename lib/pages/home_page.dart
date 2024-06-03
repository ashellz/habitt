import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/icons.dart';

Icon startIcon = const Icon(Icons.book);
Icon updatedIcon = startIcon;
TextEditingController createcontroller = TextEditingController();

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
        itemBuilder: (context, index) => ListTile(
          contentPadding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 5.0,
          ),
          leading: Icon(habitList[index][2]),
          title: Text(habitList[index][0]),
          trailing: Icon(habitList[index][1] ? Icons.check_box : Icons.close),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
        onPressed: () => showModalBottomSheet(
          enableDrag: true,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 218, 211, 190),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: MediaQuery.of(context).size.height * 2 / 3,
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
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
