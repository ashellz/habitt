import 'package:flutter/material.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/home/widgets/All%20Habits%20Page/all_habits_tag.dart';
import 'package:habitt/pages/home/widgets/adaptable_page_view.dart';
import 'package:habitt/pages/shared%20widgets/expandable_app_bar.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:provider/provider.dart';

class AllHabitsPage extends StatefulWidget {
  const AllHabitsPage({
    super.key,
    required this.editcontroller,
  });

  final TextEditingController editcontroller;

  @override
  State<AllHabitsPage> createState() => _AllHabitsPageState();
}

class _AllHabitsPageState extends State<AllHabitsPage> {
  final allHabitsPageController = PageController(initialPage: 0);
  GlobalKey sizeKey = GlobalKey();
  double? height;
  List habits = habitBox.values.toList();
  List<List<int>> habitsCategory = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataProvider>().setAllHabitsTagSelected("Categories");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boxHeight = sizeKey.currentContext?.size?.height;

      setState(() {
        height = boxHeight;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List tagsList = context.watch<DataProvider>().tagsList;
    List<double> habitBoxSizes = [];
    List<double> tagsSizes = [];
    double taskSize = 0;

    habitBoxSizes = [0, 0, 0, 0];

    for (int i = 0; i < habits.length; i++) {
      if (!habits[i].task) {
        if (habits[i].category == "Any time") {
          habitBoxSizes[0] += 55.5;
        } else if (habits[i].category == "Morning") {
          habitBoxSizes[1] += 55.5;
        } else if (habits[i].category == "Afternoon") {
          habitBoxSizes[2] += 55.5;
        } else if (habits[i].category == "Evening") {
          habitBoxSizes[3] += 55.5;
        }
      }

      if (habits[i].task == true) {
        taskSize += 55.5;
      }
    }

    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i] != "No tag") {
        tagsSizes.add(0);
        for (int j = 0; j < habits.length; j++) {
          if (habits[j].tag == tagsList[i] && !habits[j].task) {
            tagsSizes[i] += 55.5;
          }
        }
      } else {
        tagsSizes.add(0);
      }
    }

    return Scaffold(
      backgroundColor: context.watch<ColorProvider>().blackColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          ExpandableAppBar(
              actionsWidget: Container(),
              title: "All Habits"), // update to mathc bosnian
          SliverToBoxAdapter(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                child: SizedBox(
                    height: 30,
                    child: allHabitsTag(context, allHabitsPageController)),
              ),
              PageViewHeightAdaptable(
                isHomePage: false,
                key: sizeKey,
                controller: allHabitsPageController,
                children: [
                  for (String type in ['Categories', 'Tags', 'Tasks'])
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          if (type == "Categories")
                            Column(children: [
                              ReorderableCategory(
                                category: "Any time",
                                boxSize: habitBoxSizes[0],
                                type: type,
                                editController: widget.editcontroller,
                              ),
                              ReorderableCategory(
                                category: "Morning",
                                boxSize: habitBoxSizes[1],
                                type: type,
                                editController: widget.editcontroller,
                              ),
                              ReorderableCategory(
                                category: "Afternoon",
                                boxSize: habitBoxSizes[2],
                                type: type,
                                editController: widget.editcontroller,
                              ),
                              ReorderableCategory(
                                category: "Evening",
                                boxSize: habitBoxSizes[3],
                                type: type,
                                editController: widget.editcontroller,
                              ),
                            ]),
                          if (type == "Tags")
                            Column(children: [
                              for (int i = 0; i < tagsList.length; i++)
                                if (tagsList[i] != "No tag")
                                  ReorderableCategory(
                                    category: tagsList[i],
                                    boxSize: tagsSizes[i],
                                    type: type,
                                    editController: widget.editcontroller,
                                  ),
                            ]),
                          if (type == "Tasks")
                            ReorderableCategory(
                              category: "Tasks",
                              boxSize: taskSize,
                              type: type,
                              editController: widget.editcontroller,
                            ),
                          SizedBox(
                            height: height == null
                                ? 0
                                : height! > MediaQuery.of(context).size.height
                                    ? 0
                                    : MediaQuery.of(context).size.height -
                                        height!,
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class ReorderableCategory extends StatefulWidget {
  const ReorderableCategory(
      {super.key,
      required this.category,
      required this.boxSize,
      required this.type,
      required this.editController});

  final String category;
  final double boxSize;
  final String type;
  final TextEditingController editController;

  @override
  State<ReorderableCategory> createState() => _ReorderableCategoryState();
}

class _ReorderableCategoryState extends State<ReorderableCategory> {
  Color evenItemColor = Colors.grey.shade900;
  Color oddItemColor = Colors.grey.shade800;
  List habits = List.from(habitBox.values.toList());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(translateBoth(widget.category, context),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
            height: widget.boxSize,
            child: ReorderableList(
              itemBuilder: (context, i) {
                if (widget.type == "Categories") {
                  if (habits[i].category == widget.category) {
                    if (!habits[i].task) {
                      return Tile(
                        key: ValueKey(habits[i].id),
                        habits: habits,
                        evenItemColor: evenItemColor,
                        oddItemColor: oddItemColor,
                        i: i,
                        editcontroller: widget.editController,
                      );
                    }
                  }
                } else if (widget.type == "Tags") {
                  if (habits[i].tag == widget.category) {
                    if (!habits[i].task) {
                      return Tile(
                        key: ValueKey(habits[i].id),
                        habits: habits,
                        evenItemColor: evenItemColor,
                        oddItemColor: oddItemColor,
                        i: i,
                        editcontroller: widget.editController,
                      );
                    }
                  }
                } else if (widget.type == "Tasks") {
                  if (habits[i].task == true) {
                    return Tile(
                      key: ValueKey(habits[i].id),
                      habits: habits,
                      evenItemColor: evenItemColor,
                      oddItemColor: oddItemColor,
                      i: i,
                      editcontroller: widget.editController,
                    );
                  }
                }

                return Container(
                  key: ValueKey(habits[i].id),
                );
              },
              itemCount: habits.length,
              onReorder: (int oldIndex, int newIndex) async {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final HabitData item = habits.removeAt(oldIndex);
                  habits.insert(newIndex, item);
                });

                await habitBox.clear(); // Clear the existing entries
                for (var habit in habits) {
                  await habitBox
                      .add(habit); // Add the updated list back to the box
                }
              },
            ))
      ]),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.habits,
    required this.evenItemColor,
    required this.oddItemColor,
    required this.i,
    required this.editcontroller,
  });

  final List habits;
  final Color evenItemColor;
  final Color oddItemColor;
  final int i;
  final TextEditingController editcontroller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(
          convertIcon(habits[i].icon),
        ),
        title: Text(
          habits[i].name,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.read<HabitProvider>().resetSomethingEdited();
                context.read<HabitProvider>().resetAppearenceEdited();
                Provider.of<HabitProvider>(context, listen: false)
                    .habitGoalValue = 0;
                updated = false;
                editcontroller.text = "";
                changed = false;
                deleted = false;

                int id = habits[i].id;
                HabitData habit = habits[i];

                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => EditHabitPage(
                              id: id,
                              editcontroller: editcontroller,
                            )))
                    .whenComplete(() {
                  bool changeTag = true;
                  for (int i = 0; i < tagBox.length; i++) {
                    if (tagBox.getAt(i)!.tag == habit.tag) {
                      changeTag = false;
                      break;
                    }
                  }
                  if (changeTag) {
                    habit.tag = habitTag;
                    changeTag = true;
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<HabitProvider>().setTagSelected(
                        "All"); //TODO: only change if selected tag is deleted
                  });
                  pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );

                  deleted = false;
                  updated = false;
                  editcontroller.clear();
                  changed = false;
                  if (context.mounted) {
                    context.read<DataProvider>().updateHabits();
                    context.read<HabitProvider>().changeNotification([]);
                    Provider.of<HabitProvider>(context, listen: false)
                        .habitGoalValue = 0;
                  }
                });
              },
            ),
            ReorderableDragStartListener(
              index: i,
              child: const Icon(Icons.drag_handle),
            ),
          ],
        ),
      ),
    );
  }
}
