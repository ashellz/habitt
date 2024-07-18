import 'package:flutter/material.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/add_habit_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/menu/menu_page.dart';
import 'package:habit_tracker/util/objects/new_habit_tile.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  @override
  Widget build(BuildContext context) {
    String username = stringBox.get('username') ?? 'Guest';
    anyTimeHeight = 200;
    for (int i = 1; i < habitBox.length; i++) {
      anyTimeHeight += 70;
    }

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
            mainCategoryList(),
            const SizedBox(height: 20),
            otherCategoriesList(),
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

Widget mainCategoryList() {
  return Stack(
    children: [
      Container(
        height: anyTimeHeight, // change
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 55, 54, 54),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 95),
            for (int i = 0; i < habitBox.length; i++)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: NewHabitTile(
                  index: i,
                ),
              ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theOtherGreen,
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Main category name",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}

otherCategoriesList() {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    anyTime(),
    const SizedBox(height: 20),
    morning(),
    const SizedBox(height: 20),
    afternoon(),
    const SizedBox(height: 20),
    evening(),
  ]);
}

Widget anyTime() {
  if (anytimeHasHabits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Any time",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitBox.length; i++)
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

Widget morning() {
  if (morningHasHabits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Morning",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitBox.length; i++)
          if (habitBox.getAt(i)?.category == 'Morning')
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

Widget afternoon() {
  if (afternoonHasHabits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Afternoon",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitBox.length; i++)
          if (habitBox.getAt(i)?.category == 'Afternoon')
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

Widget evening() {
  if (eveningHasHabits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Evening",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitBox.length; i++)
          if (habitBox.getAt(i)?.category == 'Evening')
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
