import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_data.dart';
import 'package:habit_tracker/data/historical_habit.dart';
import 'package:habit_tracker/data/tags.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/Add%20Habit%20Page/add_habit_page.dart';
import 'package:habit_tracker/pages/menu/menu_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/functions/habit/calculateHeight.dart';
import 'package:habit_tracker/util/functions/habit/habitsCompleted.dart';
import 'package:habit_tracker/util/objects/habit/habit_tile.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

Icon startIcon = const Icon(Icons.book);

final habitBox = Hive.box<HabitData>('habits');
final metadataBox = Hive.box<DateTime>('metadata');
final streakBox = Hive.box<int>('streak');
final boolBox = Hive.box<bool>('bool');
final stringBox = Hive.box<String>('string');
final listBox = Hive.box<List>('list');
final tagBox = Hive.box<TagData>('tags');
final historicalBox = Hive.box<HistoricalHabit>('historicalHabits');
final historicalHabitDataBox =
    Hive.box<HistoricalHabitData>('historicalHabitData');
late HabitData myHabit;
String habitTag = "";
final player = AudioPlayer();

bool changed = false, keepData = false, deleted = false;

List<String> categoriesList = ['All'];
List<String> tagsList = [
  'No tag',
  'Healthy Lifestyle',
  'Better Sleep',
  'Morning Routine',
  'Workout',
];

List<String> greetingTexts = [
  "Hi there",
  "Hey there",
  "Hello there",
  "Hello",
  "Hi",
  "Hey",
  "What's up?",
];
String greetingText = greetingTexts[Random().nextInt(greetingTexts.length)];

final pageController = PageController(initialPage: 0);

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    hasHabits();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HabitProvider>().updateLastOpenedDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    fillTagsList(context);
    String? tagSelected = context.watch<HabitProvider>().tagSelected;

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
            openAddHabitPage(context, createcontroller);
          },
          backgroundColor: theLightColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  header(username),
                  const SizedBox(height: 20),
                  SizedBox(height: 30, child: tagsWidgets(tagSelected)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(
              height: calculateHabitsHeight(tagSelected, context),
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (value) => context
                    .read<HabitProvider>()
                    .setTagSelected(visibleListTags()[value]),
                children: [
                  for (String tag in visibleListTags())
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 40),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const SizedBox(height: 20),
                          if (tag == 'All')
                            Column(children: [
                              mainCategoryList(
                                  habitListLength,
                                  mainCategoryHeight,
                                  mainCategory,
                                  editcontroller,
                                  context),
                              const SizedBox(height: 20),
                              otherCategoriesList(habitListLength, mainCategory,
                                  editcontroller, anytimeHasHabits)
                            ]),
                          if (tag != 'All')
                            tagSelectedWidget(tag, editcontroller),
                        ],
                      ),
                    ),
                ],
              ),
            )
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
      Text(
        greetingText,
        style: const TextStyle(
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
            color: theLightColor,
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
          color: theOtherColor,
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
    anyTime(habitListLength, editcontroller, mainCategory, false),
    morning(habitListLength, mainCategory, editcontroller, false),
    afternoon(habitListLength, mainCategory, editcontroller, false),
    evening(habitListLength, mainCategory, editcontroller, false),
  ]);
}

Widget tagSelectedWidget(tagSelected, editcontroller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(tagSelected,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      for (int i = 0; i < habitBox.length; i++)
        if (habitBox.getAt(i)?.category == tagSelected ||
            habitBox.getAt(i)?.tag == tagSelected)
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

Widget anyTime(habitListLength, editcontroller, mainCategory, bool tag) {
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
    }
  }
  return Container();
}

Widget morning(habitListLength, mainCategory, editcontroller, bool tag) {
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

Widget afternoon(habitListLength, mainCategory, editcontroller, bool tag) {
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

Widget evening(habitListLength, mainCategory, editcontroller, bool tag) {
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

List<String> visibleListTags() {
  List<String> visibleList = ["All"];

  for (int i = 0; i < habitBox.length; i++) {
    final category = habitBox.getAt(i)?.category;

    if (!visibleList.contains(category)) {
      visibleList.add(category!);
    }
  }

  visibleList.sort((a, b) {
    const order = ["All", "Any time", "Morning", "Afternoon", "Evening"];
    return order.indexOf(a).compareTo(order.indexOf(b));
  });

  for (int i = 0; i < habitBox.length; i++) {
    final tag = habitBox.getAt(i)?.tag;
    if (!visibleList.contains(tag)) {
      if (tag != "No tag") {
        visibleList.add(tag!);
      }
    }
  }

  return visibleList;
}

Widget tagsWidgets(String? tagSelected) {
  List<String> visibleList = visibleListTags();

  return ListView(
    scrollDirection: Axis.horizontal,
    children: <Widget>[
      for (final category in visibleList)
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () => setState(() {
                      pageController.animateToPage(
                        visibleList.indexOf(category),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          tagSelected == category ? theOtherColor : theDarkGrey,
                    ),
                    height: 30,
                    child: Center(
                      child: Text(category.toString(),
                          style: TextStyle(
                              color: categoryCompleted(category)
                                  ? Colors.grey.shade700
                                  : Colors.white,
                              decorationThickness: 3.0)),
                    ))),
          ),
        )
    ],
  );
}

void fillTagsList(BuildContext context) {
  categoriesList = ["All"];

  void addAnytime() {
    if (!categoriesList.contains("Any time")) {
      categoriesList.add("Any time");
    }
  }

  void addMorning() {
    if (!categoriesList.contains("Morning")) {
      categoriesList.add("Morning");
    }
  }

  void addAfternoon() {
    if (!categoriesList.contains("Afternoon")) {
      categoriesList.add("Afternoon");
    }
  }

  void addEvening() {
    if (!categoriesList.contains("Evening")) {
      categoriesList.add("Evening");
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
      categoriesList.remove("Any time");
    }
    if (morningHasHabits) {
      addMorning();
    } else {
      categoriesList.remove("Morning");
    }
    if (afternoonHasHabits) {
      addAfternoon();
    } else {
      categoriesList.remove("Afternoon");
    }
    if (eveningHasHabits) {
      addEvening();
    } else {
      categoriesList.remove("Evening");
    }
  }

  categoriesList.sort((a, b) {
    const order = ["All", "Any time", "Morning", "Afternoon", "Evening"];
    return order.indexOf(a).compareTo(order.indexOf(b));
  });

  for (int i = 0; i < tagBox.length; i++) {
    String tag = tagBox.getAt(i)!.tag;
    if (!tagsList.contains(tag)) {
      tagsList.add(tag);
    }
  }

  for (int i = 0; i < tagsList.length; i++) {
    if (tagsList[i] != 'No tag' && !categoriesList.contains(tagsList[i])) {
      categoriesList.add(tagsList[i]);
    }
  }
}

Future<void> playSound() async {
  await player.play(AssetSource('sound/complete3.mp3'));
}

void openAddHabitPage(
    BuildContext context, TextEditingController createcontroller) {
  Provider.of<HabitProvider>(context, listen: false).notescontroller.clear();
  habitTag = "No tag";
  Provider.of<HabitProvider>(context, listen: false).updatedIcon = startIcon;
  Provider.of<HabitProvider>(context, listen: false).habitGoalValue = 0;
  Provider.of<HabitProvider>(context, listen: false).dropDownValue = 'Any time';
  Provider.of<HabitProvider>(context, listen: false).habitGoalController.text =
      "times";
  Provider.of<HabitProvider>(context, listen: false).amount = 2;
  Provider.of<HabitProvider>(context, listen: false).durationMinutes = 0;
  Provider.of<HabitProvider>(context, listen: false).durationHours = 0;
  Provider.of<HabitProvider>(context, listen: false).duration = 0;
  createcontroller.text = "Habit Name";

  Provider.of<HabitProvider>(context, listen: false).categoriesExpanded = false;

  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return AddHabitPage(
      createcontroller: createcontroller,
    );
  })).whenComplete(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().setTagSelected("All");
    });
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    if (context.mounted) {
      Provider.of<HabitProvider>(context, listen: false)
          .notescontroller
          .clear();

      Provider.of<HabitProvider>(context, listen: false).updatedIcon =
          startIcon;

      Provider.of<HabitProvider>(context, listen: false).dropDownValue =
          'Any time';
    }
    habitTag = "No tag";

    amountNameController.text = "times";
    createcontroller.text = "Habit Name";
  });
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
