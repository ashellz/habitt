import 'package:flutter/material.dart';
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const AddHabitPage();
            }));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: theLightGreen,
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
          color: theDarkGrey,
        ),
        child: Column(
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
    morning(),
    afternoon(),
    evening(),
  ]);
}

Widget anyTime() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Any time",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      for (int i = 0; i < habitBox.length; i++)
        if (habitBox.getAt(i)?.category == 'Any time') NewHabitTile(index: i),
    ],
  );
}

Widget morning() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Morning",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      for (int i = 0; i < habitBox.length; i++)
        if (habitBox.getAt(i)?.category == 'Morning') NewHabitTile(index: i),
    ],
  );
}

Widget afternoon() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Afternoon",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      for (int i = 0; i < habitBox.length; i++)
        if (habitBox.getAt(i)?.category == 'Afternoon') NewHabitTile(index: i),
    ],
  );
}

Widget evening() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Evening",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      for (int i = 0; i < habitBox.length; i++)
        if (habitBox.getAt(i)?.category == 'Evening') NewHabitTile(index: i),
    ],
  );
}
