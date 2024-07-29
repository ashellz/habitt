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

final habitBox = Hive.box<HabitData>('habits');
final metadataBox = Hive.box<DateTime>('metadata');
final streakBox = Hive.box<int>('streak');
final boolBox = Hive.box<bool>('bool');
final stringBox = Hive.box<String>('string');
late HabitData myHabit;
String dropDownValue = 'Any time';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().chooseMainCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().updateMainCategoryHeight();
    });

    String mainCategory = context.watch<HabitProvider>().mainCategory;
    int habitListLength = context.watch<HabitProvider>().habitListLength;
    double mainCategoryHeight =
        context.watch<HabitProvider>().mainCategoryHeight;
    String username = stringBox.get('username') ?? 'Guest';

    TextEditingController createcontroller = TextEditingController();
    TextEditingController editcontroller = TextEditingController();

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
            updatedIcon = startIcon;
            habitGoal = 0;
            dropDownValue = 'Any time';
            amountNameController.text = "times";
            amountController.text = "2";
            currentAmountValue = 2;
            currentDurationValueHours = 0;
            currentDurationValueMinutes = 0;
            createcontroller.text = "Habit Name";

            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddHabitPage(
                createcontroller: createcontroller,
              );
            })).whenComplete(() {
              updatedIcon = startIcon;
              habitGoal = 0;
              dropDownValue = 'Any time';
              amountNameController.text = "times";
              amountController.text = "2";
              currentAmountValue = 2;
              currentDurationValueHours = 0;
              currentDurationValueMinutes = 0;
              createcontroller.text = "Habit Name";
            });
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
            mainCategoryList(habitListLength, mainCategoryHeight, mainCategory,
                editcontroller, context),
            const SizedBox(height: 20),
            otherCategoriesList(habitListLength, mainCategory, editcontroller,
                anytimeHasHabits),
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

Widget mainCategoryList(habitListLength, mainCategoryHeight, mainCategory,
    editcontroller, BuildContext context) {
  return Stack(
    children: [
      Container(
        height: mainCategoryHeight, // change
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theDarkGrey,
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
                              editcontroller: editcontroller,
                            ),
                          ),
                    ],
                  )
                : anyTimeMainCategory(
                    habitListLength, editcontroller, anytimeHasHabits, context)
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
                                  editcontroller: editcontroller,
                                ),
                              ),
                        ],
                      )
                    : anyTimeMainCategory(habitListLength, editcontroller,
                        anytimeHasHabits, context)
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
                                      editcontroller: editcontroller,
                                    ),
                                  ),
                            ],
                          )
                        : anyTimeMainCategory(habitListLength, editcontroller,
                            anytimeHasHabits, context)
                    : anyTimeMainCategory(habitListLength, editcontroller,
                        anytimeHasHabits, context),
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

otherCategoriesList(
    habitListLength, mainCategory, editcontroller, mainCategoryListVisible) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    anyTime(
        habitListLength, editcontroller, mainCategory, mainCategoryListVisible),
    morning(
        habitListLength, mainCategory, editcontroller, mainCategoryListVisible),
    afternoon(
        habitListLength, mainCategory, editcontroller, mainCategoryListVisible),
    evening(
        habitListLength, mainCategory, editcontroller, mainCategoryListVisible),
  ]);
}

Widget anyTime(
    habitListLength, editcontroller, mainCategory, mainCategoryListVisible) {
  if (mainCategory != 'Any time') {
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
                child: NewHabitTile(
                  index: i,
                  editcontroller: editcontroller,
                ),
              ),
          const SizedBox(height: 20),
        ],
      );
    }
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
          SizedBox(height: 20),
        ]);
  } else {
    return Container();
  }
}

Widget morning(
    habitListLength, mainCategory, editcontroller, mainCategoryListVisible) {
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
                child: NewHabitTile(
                  index: i,
                  editcontroller: editcontroller,
                ),
              ),
          const SizedBox(height: 20),
        ],
      );
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
            SizedBox(height: 20),
          ]);
    }
  }

  return Container();
}

Widget afternoon(
    habitListLength, mainCategory, editcontroller, mainCategoryListVisible) {
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
                child: NewHabitTile(
                  index: i,
                  editcontroller: editcontroller,
                ),
              ),
          const SizedBox(height: 20),
        ],
      );
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
            SizedBox(height: 20),
          ]);
    }
  }
  return Container();
}

Widget evening(
    habitListLength, mainCategory, editcontroller, mainCategoryListVisible) {
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
                child: NewHabitTile(
                  index: i,
                  editcontroller: editcontroller,
                ),
              ),
          const SizedBox(height: 20),
        ],
      );
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
            SizedBox(height: 20),
          ]);
    }
  }
  return Container();
}

Widget anyTimeMainCategory(int habitListLength, editcontroller,
    anyTimeHasHabits, BuildContext context) {
  if (anyTimeHasHabits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 95),
        for (int i = 0; i < habitListLength; i++)
          if (habitBox.getAt(i)?.category == "Any time")
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: NewHabitTile(
                index: i,
                editcontroller: editcontroller,
              ),
            ),
      ],
    );
  } else {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theDarkGrey,
      ),
      child: const Padding(
        padding: EdgeInsets.only(left: 20, top: 65),
        child: Text(
          "No habits in this category",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
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
