import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/changelog_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/login_page.dart';
import 'package:habit_tracker/pages/settings_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/services/auth_service.dart';

var streakBox = Hive.box<int>('streak');

Widget menuDrawer(context) {
  return Drawer(
    backgroundColor: const Color.fromARGB(255, 37, 67, 54),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Signed in as: ${boolBox.get('isGuest')! ? 'Guest' : stringBox.get('username') ?? 'Unknown'}",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              GestureDetector(
                  child: const Text(
                    "Sign out?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    AuthService().signOut();
                    boolBox.put('isGuest', false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  })
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildHeader(BuildContext context) {
  int streak = streakBox.get('allHabitsCompletedStreak') ?? 0;
  return Container(
    height: 140,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      color: Color.fromARGB(255, 24, 41, 33),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All habits completed streak:",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            streak == 1 ? "$streak day" : "$streak days",
            style: const TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  )),
          ListTile(
              leading: const Icon(
                Icons.update,
                color: Colors.white,
                size: 25,
              ),
              title: const Text(
                'Changelog',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangelogPage(),
                    ),
                  ))
        ],
      ),
    );
