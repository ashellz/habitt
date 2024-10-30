import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';

class AdditionalTasks extends StatefulWidget {
  const AdditionalTasks(
      {super.key,
      required this.editcontroller,
      required this.isAdLoaded,
      required this.interstitialAd});

  final TextEditingController editcontroller;
  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;

  @override
  State<AdditionalTasks> createState() => _AdditionalTasksState();
}

class _AdditionalTasksState extends State<AdditionalTasks> {
  bool hasTasks = false;

  @override
  void initState() {
    super.initState();

    for (var habit in habitBox.values) {
      if (habit.task) {
        hasTasks = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasTasks) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 80),
        child: Column(
          children: [
            const TasksDivider(),
            for (int i = 0; i < habitBox.length; i++)
              if (habitBox.getAt(i)?.task == true)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: NewHabitTile(
                    id: habitBox.getAt(i)!.id,
                    editcontroller: widget.editcontroller,
                    isAdLoaded: widget.isAdLoaded,
                    interstitialAd: widget.interstitialAd,
                  ),
                )
          ],
        ),
      );
    }
  }
}

class TasksDivider extends StatelessWidget {
  const TasksDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 30, left: 40, right: 40),
      child: Row(
        children: <Widget>[
          // Left Divider
          Expanded(
            child: Divider(
              color: Colors.grey, // Customize color
              thickness: 1, // Customize thickness
            ),
          ),
          // The Text in the middle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Additional tasks", // Customize the text
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ), // Customize text style
            ),
          ),
          // Right Divider
          Expanded(
            child: Divider(
              color: Colors.grey, // Customize color
              thickness: 1, // Customize thickness
            ),
          ),
        ],
      ),
    );
  }
}
