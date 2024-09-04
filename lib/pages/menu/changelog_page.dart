import 'package:flutter/material.dart';
import 'package:habit_tracker/util/colors.dart';

class ChangelogPage extends StatelessWidget {
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        //TITLE
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, bottom: 10),
          child: Text(
            "Changelog",
            style: TextStyle(
                fontSize: 42,
                color: theLightColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        changelogContainer("04.09.2024",
            "- Changed habit notification page appearance\n- Optimized changelog page code"),
        changelogContainer("03.09.2024",
            "- Made skip feature work properly with the calendar\n- Added more greeting messages in the home page"),
        changelogContainer("02.09.2024",
            "- Streaks are now calculated using the calendar\n- Improved the way calendar works and displays habits\n- Improved the way calendar handles empty days\n- Calendar day updates in realtime if it detects a change"),
        changelogContainer("26.08.2024",
            "- Made syncing between current day habits on home page and calendar more frequent\n- Calendar days redesign (now shows your habit progress for each day)\n- If you're changing habits in the same day as today, they will be changed in real time (now works if the habit has an amount or duration)\n- Fixed phone vibrating when habit is uncompleted instead of completed in calendar habits"),
        changelogContainer("25.08.2024",
            "- Calendar page now shows habits on a selected day and if they were completed\n- Changing habit completion in the past is now possible\n- If you're changing habits in the same day as today, they will be changed in real time (doesn't work if the habit has an amount or duration) "),
        changelogContainer("22.08.2024",
            "- Updated daily notification texts so they match every time of the day\n- Fixed preferences tab not updating visually right after pressed\n- Users are now able to choose whether they want to keep or delete their data when registering if they were previously guests\n- Data is now saved after you press 'CONTINUE AS A GUEST' if you were already a guest"),
        changelogContainer(
            "19.08.2024", "- Fixed habit notifications not working"),
        changelogContainer("18.08.2024",
            "- Fixed streak going up visually when habit is skipped\n- Fixed app not responding properly after a habit is created, edited or deleted\n- Fixed completing part of the habit not displaying unless reloaded"),
        changelogContainer("08.08.2024",
            "- Settings page redesign + new settings (ability to change time for each notification)\n- Changed sound\n- Bug fixes"),
        changelogContainer("07.08.2024",
            "- Added ability to add notifications to each habit\n- Massive changes to notifications, including MANY more notification texts and a new algorithm for selecting the right text"),
        changelogContainer("04.08.2024",
            "- Added ability to swipe on the home page to go to the next or previous tag"),
        changelogContainer("03.08.2024",
            "- Bug fixes\n- Added options to disable haptic feedback and sound"),
        changelogContainer("02.08.2024",
            "- Implemented tags\n- Added vibration and sound effects"),
        changelogContainer("01.08.2024",
            "- Fixed streaks not updating on new month\n- Other bug fixes"),
        changelogContainer("31.07.2024",
            "- Added a pane to show only the chosen category\n- Bug fixes"),
        changelogContainer("29.07.2024",
            "- Habit duration can now be up to 23 hours and 59 minutes and habit amount up to 9999 times\n- Habit completion is now displayed differently on the home page\n- Changed design when completing the habit\n- Changed design for amount and duration when adding or editing the habit\n- Changed design for the delete habit dialog\n- Changed how picking habit category works\n- Made notifications work"),
        changelogContainer("27.07.2024",
            "- Improving app responsiveness\n- Streaks are now displayed on the home page for each habit"),
        changelogContainer("26.07.2024",
            "- Made the app more responsive for different screen sizes\n- Fixed max amount when creating a habit was 90 instead of 100"),
        changelogContainer("25.07.2024",
            "- Implemented skip habit feature\n- Added bouncy scroll physics to changelog page\n- Fixed not properly unchecking a done habit for habits with duration or amount\n- Fixed app resetting streaks twice a day\n- Fixed empty space left when habit category is empty"),
        changelogContainer("21.07.2024",
            "- Working on home page\n- Fixed when first time launching the app, after signing in/up, it pulls you straight to home page before the data was downloaded\n- Fixed being stuck on sign up loading page when the email already exists\n- Having no habits is now possible\n- Improved design and added managing habit amount and duration completion to the new home page"),
        changelogContainer("17.07.2024",
            "- Redesigned profile page, changed a couple of things\n- More app design changes (loading, login, signup pages)\n- Fixed some bugs on authentication and storage\n- Added ability to delete account\n- Fixed some design issues\n- Other bug fixes"),
        changelogContainer("15.07.2024",
            "- Changed design when adding, editing or deleting a habit\n- Improved data storing\n- Added different page transition effect\n- Updated app design\n- Added profile page, along with abilities to change username"),
        changelogContainer("09.07.2024",
            "- Fixed when changing how many times you have done a habit it changes the amount of times you have to do it too\n- Fixed app stuck on loading screen after registering\n- Fixed when continuing as a guest, previous logged in account data will be shown\n- Fixed when creating a new account, also previous logged in data was shown\n- Fixed when changing amount of times or duration of the habit, on a habit that is complete, it would show 0 out of times/duration but will be completed"),
        changelogContainer("08.07.2024",
            "- Made cloud storage work and connected to accounts\n- Bug fixes\n- Minor improvements\n- Made it so you don't have to restart the app yourself to update downloaded user data\n- Added a loading screen when logging in and creating an account"),
        changelogContainer("07.07.2024",
            "- Polished sign in and sign out pages\n- Improved the way authentication works\n- Implemented sign in as a guest\n- Implemented cloud storage"),
        changelogContainer("06.07.2024",
            "- Fixed amount and duration completed don't save when leaving the app\n- Improved screen responsiveness for multiple screen widths\n- Added firebase\n- Added sign in and out pages\n- Added authentication"),
        changelogContainer("05.07.2024", "- Added changelog page"),
        changelogContainer("03.07.2024",
            "- Fixed amount and duration completed don't reset on a new day\n- Fixed on all habits completed streak when it is just 1 day streak it was displaying 1 days"),
      ]),
    );
  }
}

Widget changelogContainer(String date, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
        child: Text(
          date,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(text)]))
    ],
  );
}
