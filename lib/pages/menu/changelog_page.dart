import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/new_home_page.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          //TITLE
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, bottom: 10),
            child: Text(
              "Changelog",
              style: TextStyle(
                  fontSize: 42,
                  color: theLightGreen,
                  fontWeight: FontWeight.bold),
            ),
          ),

          // 21.07.2024
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "21.07.2024",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "- Working on home page\n- Fixed when first time launching the app, after signing in/up, it pulls you straight to home page before the data was downloaded\n- Fixed being stuck on sign up loading page when the email already exists\n-Having no habits is now possible"),
                    Text(
                        "- Improved design and added managing habit amount and duration completion to the new home page")
                  ])),

          // 17.07.2024
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "17.07.2024",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "- Redesigned profile page, changed a couple of things\n- More app design changes (loading, login, signup pages)"),
                    Text("- Fixed some bugs on authentication and storage"),
                    Text(
                        "- Added ability to delete account\n- Fixed some design issues\n- Other bug fixes"),
                  ])),

          // 15.07.2024
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "15.07.2024",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "- Changed design when adding, editing or deleting a habit\n- Improved data storing\n- Added different page transition effect"),
                    Text(
                        "- Updated app design\n- Added profile page, along with abilities to change username"),
                  ])),

          // 09.07.2024
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "09.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
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
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "08.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
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
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "07.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
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
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "06.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
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
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "05.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("- Added changelog page"),
          ),

          // 03.07.2024
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "03.07.2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
                "- Fixed amount and duration completed don't reset on a new day\n- Fixed on all habits completed streak when it is just 1 day streak it was displaying 1 days"),
          ),
        ],
      ),
    );
  }
}
