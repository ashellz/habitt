import "package:flutter/material.dart";
import "package:habit_tracker/pages/menu/changelog_page.dart";
import "package:habit_tracker/pages/menu/profile_page.dart";
import "package:habit_tracker/pages/menu/settings_page.dart";
import "package:habit_tracker/pages/new_home_page.dart";

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildHeader(context),
          buildMenuItems(context),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                "Signed in as: ${boolBox.get('isGuest')! ? 'Guest' : stringBox.get('username') ?? 'Guest'}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

Widget buildHeader(BuildContext context) {
  int streak = streakBox.get('allHabitsCompletedStreak') ?? 0;
  return SizedBox(
    height: MediaQuery.of(context).size.height / 6,
    child: Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "All habits completed streak:",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              streak == 1 ? "$streak day" : "$streak days",
              style: TextStyle(
                  color: theLightGreen,
                  fontSize: 42,
                  fontWeight: FontWeight.bold),
            ),
          ]),
    ),
  );
}

Widget buildMenuItems(BuildContext context) => Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    )),
            ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 25,
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    ))
          ],
        ),
      ),
    );
