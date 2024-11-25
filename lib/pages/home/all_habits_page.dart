import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/shared%20widgets/expandable_app_bar.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:provider/provider.dart';

class AllHabitsPage extends StatefulWidget {
  const AllHabitsPage({super.key});

  @override
  State<AllHabitsPage> createState() => _AllHabitsPageState();
}

class _AllHabitsPageState extends State<AllHabitsPage> {
  List habits = habitBox.values.toList();
  Color evenItemColor = Colors.grey.shade900;
  Color oddItemColor = Colors.grey.shade800;

  @override
  Widget build(BuildContext context) {
    List<String> visibleList = visibleListTags(context);

    return Scaffold(
      backgroundColor: context.watch<ColorProvider>().blackColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          ExpandableAppBar(actionsWidget: Container(), title: "All Habits"),
          for (String tag in visibleList)
            SliverReorderableList(
              key: ValueKey(tag),
              itemCount: habits.length,
              itemBuilder: (context, index) => Padding(
                key: ValueKey('$index'),
                padding: const EdgeInsets.all(10),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    tileColor: index % 2 == 0 ? oddItemColor : evenItemColor,
                    title: Text(habits[index].name),
                    trailing: ReorderableDragStartListener(
                        index: index, child: const Icon(Icons.drag_handle)),
                  ),
                ),
              ),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final HabitData item = habits.removeAt(oldIndex);
                  habits.insert(newIndex, item);
                });
              },
            ),
        ],
      ),
    );
  }
}
