import 'package:audioplayers/audioplayers.dart';
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
final player = AudioPlayer();

bool eveningVisible = false,
    anyTimeVisible = false,
    afternoonVisible = false,
    morningVisible = false,
    changed = false,
    deleted = false;

List<String> tagsList = ['All'];

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
    hasHabits();
    openCategory();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().chooseMainCategory();
    });
  }

  String? tagSelected = 'All';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().updateMainCategoryHeight();
    });
    fillTagsList(context);

    String mainCategory = context.watch<HabitProvider>().mainCategory;
    int habitListLength = context.watch<HabitProvider>().habitListLength;
    double mainCategoryHeight =
        context.watch<HabitProvider>().mainCategoryHeight;
    String username = stringBox.get('username') ?? 'Guest';

    TextEditingController createcontroller = TextEditingController();
    TextEditingController editcontroller = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
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
            SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  for (String tag in tagsList)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          tagSelected = tag;
                        }),
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: tagSelected == tag
                                  ? theOtherGreen
                                  : theDarkGrey,
                            ),
                            height: 30,
                            child: Center(child: Text(tag))),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (tagSelected == 'All')
              Column(children: [
                mainCategoryList(habitListLength, mainCategoryHeight,
                    mainCategory, editcontroller, context),
                const SizedBox(height: 20),
                otherCategoriesList(habitListLength, mainCategory,
                    editcontroller, anytimeHasHabits)
              ]),
            if (tagSelected == 'Any time')
              anyTime(habitListLength, editcontroller, mainCategory,
                  anytimeHasHabits, true),
            if (tagSelected == 'Morning')
              morning(habitListLength, mainCategory, editcontroller,
                  anytimeHasHabits, true),
            if (tagSelected == 'Afternoon')
              afternoon(habitListLength, mainCategory, editcontroller,
                  anytimeHasHabits, true),
            if (tagSelected == 'Evening')
              evening(habitListLength, mainCategory, editcontroller,
                  anytimeHasHabits, true),
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
    anyTime(habitListLength, editcontroller, mainCategory,
        mainCategoryListVisible, false),
    morning(habitListLength, mainCategory, editcontroller,
        mainCategoryListVisible, false),
    afternoon(habitListLength, mainCategory, editcontroller,
        mainCategoryListVisible, false),
    evening(habitListLength, mainCategory, editcontroller,
        mainCategoryListVisible, false),
  ]);
}

Widget anyTime(habitListLength, editcontroller, mainCategory,
    mainCategoryListVisible, bool tag) {
  if (mainCategory != 'Any time' || tag) {
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

Widget morning(habitListLength, mainCategory, editcontroller,
    mainCategoryListVisible, bool tag) {
  if (mainCategory != 'Morning' || tag) {
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

Widget afternoon(habitListLength, mainCategory, editcontroller,
    mainCategoryListVisible, bool tag) {
  if (mainCategory != 'Afternoon' || tag) {
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

Widget evening(habitListLength, mainCategory, editcontroller,
    mainCategoryListVisible, bool tag) {
  if (mainCategory != 'Evening' || tag) {
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
/*
void chooseSelectedWidget(tagSelected, editcontroller, context) {
    if (tagSelected == 'All') {
      _selectedWidget = defaultWidget(editcontroller, context);
    } else if (tagSelected == 'Any time') {
      _selectedWidget = anyTime(habitListLength, editcontroller, mainCategory,
          anytimeHasHabits, true);
    } else if (tagSelected == 'Morning') {
      _selectedWidget = morning(habitListLength, mainCategory, editcontroller,
          anytimeHasHabits, true);
    } else if (tagSelected == 'Afternoon') {
      _selectedWidget = afternoon(habitListLength, mainCategory, editcontroller,
          anytimeHasHabits, true);
    } else if (tagSelected == 'Evening') {
      _selectedWidget = evening(habitListLength, mainCategory, editcontroller,
          anytimeHasHabits, true);
    } else {
      _selectedWidget = defaultWidget(editcontroller, context);
    }
    notifyListeners();
  }*/

void fillTagsList(BuildContext context) {
  void addAnytime() {
    if (!tagsList.contains("Any time")) {
      tagsList.add("Any time");
    }
  }

  void addMorning() {
    if (!tagsList.contains("Morning")) {
      tagsList.add("Morning");
    }
  }

  void addAfternoon() {
    if (!tagsList.contains("Afternoon")) {
      tagsList.add("Afternoon");
    }
  }

  void addEvening() {
    if (!tagsList.contains("Evening")) {
      tagsList.add("Evening");
    }
  }

  if (context.watch<HabitProvider>().displayEmptyCategories) {
    addAnytime();
    addMorning();
    addAfternoon();
    addEvening();
  } else {
    if (anytimeHasHabits) {
      addAnytime();
    } else {
      tagsList.remove("Any time");
    }
    if (morningHasHabits) {
      addMorning();
    } else {
      tagsList.remove("Morning");
    }
    if (afternoonHasHabits) {
      addAfternoon();
    } else {
      tagsList.remove("Afternoon");
    }
    if (eveningHasHabits) {
      addEvening();
    } else {
      tagsList.remove("Evening");
    }
  }

  tagsList.sort((a, b) {
    const order = ["All", "Any time", "Morning", "Afternoon", "Evening"];
    return order.indexOf(a).compareTo(order.indexOf(b));
  });
}

Future<void> playSound() async {
  print("the functio nwas run");
  await player.play(AssetSource('sound/complete1.mp3'));
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
