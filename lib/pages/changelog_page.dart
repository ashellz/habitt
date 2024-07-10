import 'package:flutter/material.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 211, 190),
      appBar: AppBar(
        title: const Text("Changelog"),
        centerTitle: true,
        toolbarHeight: 80.0,
        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
      ),
      body: ListView(
        children: const [
          // 09.07.2024
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "09.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "- Fixed when changing how many times you have done a habit it changes the amount of times you have to do it too\n- Fixed ap stuck on loading screen after registering"),
                    Text(
                        "- Fixed when continuing as a guest, previous logged in account data will be shown\n- Fixed when creating a new account, also previous logged in data was shown"),
                    Text(
                        "- Fixed when changing amount of times or duration of the habit, on a habit that is complete, it would show 0 out of times/duration but will be completed"),
                  ])),

          // 08.07.2024
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "08.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "- Made cloud storage work and connected to accounts\n- Bug fixes\n- Minor improvements\n- Made it so you don't have to restart the app yourself to update downloaded user data"),
                    Text(
                        "- Added a loading screen when logging in and creating an account")
                  ])),

          // 07.07.2024
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "07.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "- Polished sign in and sing out pages\n- Improved the way authentication works\n- Implemented sign in as a guest"),
                Text("- Implemented cloud storage"),
              ],
            ),
          ),

          // 06.07.2024
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "06.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "- Fixed amount and duration completed don't save when leaving the app\n- Improved screen responsivnes for multiple screen widths"),
                Text(
                    "- Added firebase\n- Added sign in and out pages\n- Added authentication"),
              ],
            ),
          ),

          // 05.07.2024
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "05.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("- Added changelog page"),
          ),

          // 03.07.2024
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "03.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
                "- Fixed amount and duration completed don't reset on a new day\n- Fixed on all habits completed streak when it is just 1 day streak it was displaying 1 days"),
          ),
        ],
      ),
    );
  }
}
