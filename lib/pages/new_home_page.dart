import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/add_habit_page.dart';
import 'package:habit_tracker/pages/menu/menu_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/functions/updateLastOpenedDate.dart';
import 'package:habit_tracker/util/objects/new_habit_tile.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

Color theDarkGrey = const Color.fromARGB(255, 17, 17, 17);
Color theDarkGreen = const Color.fromARGB(255, 37, 67, 54);
Color theGreen = const Color.fromARGB(255, 62, 80, 71);
Color theOtherGreen = const Color.fromARGB(255, 107, 138, 122);
Color theLightGreen = const Color.fromARGB(255, 124, 175, 151);
Color theRedColor = const Color.fromARGB(255, 204, 86, 110);
Color theYellowColor = const Color.fromARGB(255, 223, 223, 129);

Icon startIcon = const Icon(Icons.book);
Icon updatedIcon = startIcon;
final createcontroller = TextEditingController();
final editcontroller = TextEditingController();
final habitBox = Hive.box<HabitData>('habits');
final metadataBox = Hive.box<DateTime>('metadata');
final streakBox = Hive.box<int>('streak');
final boolBox = Hive.box<bool>('bool');
final stringBox = Hive.box<String>('string');
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

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  @override
  void initState() {
    super.initState();
    updateLastOpenedDate();
  }

  @override
  Widget build(BuildContext context) {
    int habitListLength = context.watch<HabitProvider>().habitListLength;
    double mainCategoryHeight =
        context.watch<HabitProvider>().mainCategoryHeight;

    context.read<HabitProvider>().updateMainCategoryHeight();

    String username = stringBox.get('username') ?? 'Guest';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.black, actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const MenuPage();
              }));
            },
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createcontroller.clear();
            updatedIcon = startIcon;
            habitGoal = 0;
            dropDownValue = 'Any time';
            amountNameController.text = "times";
            currentAmountValue = 2;
            currentDurationValue = 1;
            if (createcontroller.text.isEmpty) {
              createcontroller.text = "Habit Name";
            }
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const AddHabitPage();
            }));
          },
          backgroundColor: theLightGreen,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
          children: [
            const SizedBox(height: 30),
            header(username),
            const SizedBox(height: 20),
            mainCategoryList(habitListLength, mainCategoryHeight),
            const SizedBox(height: 20),
            otherCategoriesList(habitListLength),
          ],
        ),
      ),
    );
  }
}

Widget header(username) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Hi there",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      Transform.translate(
        offset: const Offset(0, -10),
        child: Text(
          username,
          style: TextStyle(
            color: theLightGreen,
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

Widget mainCategoryList(habitListLength, mainCategoryHeight) {
  return Stack(
    children: [
      Container(
        height: mainCategoryHeight, // change
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade800,
        ),
        child: mainCategory == "Morning"
            ? morningHasHabits
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 95),
                      for (int i = 0; i < habitListLength; i++)
                        if (habitBox.getAt(i)?.category == mainCategory)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: NewHabitTile(
                              index: i,
                            ),
                          ),
                    ],
                  )
                : const Column(children: [
                    SizedBox(
                      width: double.infinity,
                      height: 125,
                    ),
                    Text(
                      "No habits in this category",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ])
            : mainCategory == "Afternoon"
                ? afternoonHasHabits
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 95),
                          for (int i = 0; i < habitListLength; i++)
                            if (habitBox.getAt(i)?.category == mainCategory)
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: NewHabitTile(
                                  index: i,
                                ),
                              ),
                        ],
                      )
                    : const Column(children: [
                        SizedBox(
                          width: double.infinity,
                          height: 125,
                        ),
                        Text(
                          "No habits in this category",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ])
                : mainCategory == "Evening"
                    ? eveningHasHabits
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 95),
                              for (int i = 0; i < habitListLength; i++)
                                if (habitBox.getAt(i)?.category == mainCategory)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: NewHabitTile(
                                      index: i,
                                    ),
                                  ),
                            ],
                          )
                        : const Column(children: [
                            SizedBox(
                              width: double.infinity,
                              height: 125,
                            ),
                            Text(
                              "No habits in this category",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ])
                    : Container(),
      ),
      Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theOtherGreen,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            mainCategory,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}

otherCategoriesList(habitListLength) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    anyTime(habitListLength),
    const SizedBox(height: 20),
    morning(habitListLength),
    const SizedBox(height: 20),
    afternoon(habitListLength),
    const SizedBox(height: 20),
    evening(habitListLength),
  ]);
}

Widget anyTime(habitListLength) {
  if (anytimeHasHabits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Any time",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitBox.getAt(i)?.category == 'Any time')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: NewHabitTile(index: i),
            ),
      ],
    );
  }

  if (boolBox.get("displayEmptyCategories")!) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Any time",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        ]);
  } else {
    return Container();
  }
}

Widget morning(habitListLength) {
  if (mainCategory != 'Morning') {
    if (morningHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Morning",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == 'Morning')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(index: i),
              ),
        ],
      );
    }
  }
  if (boolBox.get("displayEmptyCategories")!) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Morning",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        ]);
  } else {
    return Container();
  }
}

Widget afternoon(habitListLength) {
  if (mainCategory != 'Afternoon') {
    if (afternoonHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Afternoon",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == 'Afternoon')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(index: i),
              ),
        ],
      );
    }
  }
  if (boolBox.get("displayEmptyCategories")!) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Afternoon",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        ]);
  } else {
    return Container();
  }
}

Widget evening(habitListLength) {
  if (mainCategory != 'Evening') {
    if (eveningHasHabits) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Evening",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          for (int i = 0; i < habitListLength; i++)
            if (habitBox.getAt(i)?.category == 'Evening')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(index: i),
              ),
        ],
      );
    }
  }
  if (boolBox.get("displayEmptyCategories")!) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Evening",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        ]);
  } else {
    return Container();
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
