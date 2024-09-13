import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_spinbox/material.dart";
import "package:habit_tracker/data/habit_tile.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/buildEditedValues.dart";
import "package:habit_tracker/pages/habit/Shared%20Widgets/habit_display.dart";
import "package:habit_tracker/pages/habit/icons_page.dart";
import "package:habit_tracker/pages/habit/notifications_page.dart";
import "package:habit_tracker/pages/new_home_page.dart";
import "package:habit_tracker/services/provider/habit_provider.dart";
import "package:habit_tracker/util/colors.dart";
import "package:habit_tracker/util/functions/checkForNotifications.dart";
import "package:habit_tracker/util/functions/validate_text.dart";
import "package:habit_tracker/util/objects/habit/add_tag.dart";
import "package:habit_tracker/util/objects/habit/confirm_delete_habit.dart";
import "package:habit_tracker/util/objects/habit/delete_tag.dart";
import "package:provider/provider.dart";
import "package:vibration/vibration.dart";

int habitGoalEdit = 0;

bool updated = false;
bool dropDownChanged = false;
late int amount;
late int duration;
late int durationHours;
late int durationMinutes;

TextEditingController amountNameControllerEdit = TextEditingController();
TextEditingController amountControllerEdit = TextEditingController();

final formKey = GlobalKey<FormState>();

class EditHabitPage extends StatefulWidget {
  const EditHabitPage({
    super.key,
    required this.index,
    required this.editcontroller,
  });

  final int index;
  final TextEditingController editcontroller;

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  bool edit = false;
  bool stats = true;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final editcontroller = widget.editcontroller;
    final desccontroller = context.watch<HabitProvider>().notescontroller;

    buildEditedValues(context, widget.index, editcontroller);

    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    PageController pageController = PageController();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, actions: [
        PopupMenuButton(
          color: Colors.grey.shade900,
          itemBuilder: (context) => [
            PopupMenuItem(
                onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const NotificationsPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    ).whenComplete(() => checkForNotifications()),
                value: 0,
                child: const Row(
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(width: 5),
                    Text(
                      "Notifications",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            PopupMenuItem(
                onTap: () => showDialog(
                        context: context,
                        builder: (context) => confirmDeleteHabit(
                            widget.index, editcontroller)).then((value) {
                      if (deleted) {
                        if (context.mounted) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      }
                    }),
                value: 1,
                child: const Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 5),
                    Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
          ],
        ),
      ]),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent),
        child: BottomNavigationBar(
            enableFeedback: false,
            backgroundColor: theDarkGrey,
            unselectedItemColor: Colors.grey.shade700,
            selectedItemColor: Colors.white,
            currentIndex: currentIndex,
            onTap: (int value) => setState(() {
                  currentIndex = value;
                  pageController.animateToPage(
                    value,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.percent_outlined),
                label: 'Stats',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.edit,
                ),
                label: 'Edit',
              ),
            ]),
      ),
      body: Form(
        key: formKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
                padding: const EdgeInsets.only(bottom: 60, left: 10, right: 10),
                physics: const BouncingScrollPhysics(),
                children: [
                  HabitDisplay(controller: editcontroller),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        if (value == 0) {
                          setState(() {
                            currentIndex = 0;
                          });
                        } else {
                          setState(() {
                            currentIndex = 1;
                          });
                        }
                      },
                      physics: const BouncingScrollPhysics(),
                      controller: pageController,
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: index == 0
                              ? statsWidgets(context, widget.index)
                              : editWidgets(
                                  setState,
                                  context,
                                  editcontroller,
                                  desccontroller,
                                  widget.index,
                                  dropDownChanged),
                        );
                      },
                    ),
                  ),
                ]),
            Visibility(
              visible: context.watch<HabitProvider>().somethingEdited,
              child: Transform.translate(
                offset: Offset(0, keyboardOpen ? 100 : 0),
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theLightColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                    ),
                    child: const Text('Save Changes',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Provider.of<HabitProvider>(context, listen: false)
                            .editHabitProvider(
                                widget.index, context, editcontroller);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

Widget statsWidgets(BuildContext context, int index) {
  var habit = habitBox.getAt(index)!;
  int timesCompleted = 0;
  int timesMissed = 0;
  int timesSkipped = 0;

  for (int i = 0; i < historicalBox.length; i++) {
    int dataLength = historicalBox.getAt(i)!.data.length;
    if (index < dataLength) {
      if (historicalBox.getAt(i)!.data[index].completed) {
        if (historicalBox.getAt(i)!.data[index].skipped) {
          timesSkipped++;
        } else {
          timesCompleted++;
        }
      } else {
        timesMissed++;
      }
    }
  }

  Widget box(String text, var value, bool perc) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width * 0.5 - 30,
        height: MediaQuery.of(context).size.width * 0.5 - 30,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.grey.shade900),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              minFontSize: 12,
              text.split(" ")[0],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            AutoSizeText(
              minFontSize: 12,
              text.split(" ")[1],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              perc ? "${value.toString()}%" : value.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: theLightColor),
            ),
          ],
        ),
      ),
    );
  }

  String habitCompleted() {
    if (habit.completed) {
      if (habit.skipped) {
        return "Skipped";
      } else {
        return "Completed";
      }
    } else {
      return "Not Completed";
    }
  }

  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(children: [
      Center(
        child: TextButton(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all<Size>(
                Size(MediaQuery.of(context).size.width, 50)),
            backgroundColor: WidgetStateProperty.all<Color>(habit.skipped
                ? Colors.grey.shade900
                : habit.completed
                    ? theOtherColor
                    : Colors.grey.shade900),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          onPressed: () {
            Provider.of<HabitProvider>(context, listen: false)
                .completeHabitProvider(index);
          },
          child: Text(
            habitCompleted(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      const SizedBox(
        height: 25,
      ),
      streakStats(habit: habit),
      const SizedBox(
        height: 25,
      ),
      SizedBox(
        height: MediaQuery.of(context).size.width * 0.5 - 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            box("Times completed", timesCompleted, false),
            box("Times skipped", timesSkipped, false),
            box("Times missed", timesMissed, false)
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          box(
              "Completion rate",
              (timesCompleted /
                      (timesCompleted + timesSkipped + timesMissed) *
                      100)
                  .toInt(),
              true),
          const Spacer(),
        ],
      ),
    ]),
  );
}

class streakStats extends StatelessWidget {
  const streakStats({
    super.key,
    required this.habit,
  });

  final HabitData habit;

  Color bestStreakColor() {
    Color color = Colors.white;

    if (habit.streak == habit.longestStreak) {
      color = theOtherColor;
    }

    return color;
  }

  String displayBestStreak() {
    late String bestStreak;

    if (habit.streak == habit.longestStreak) {
      if (habit.completed) {
        bestStreak = (habit.streak + 1).toString();
      } else {
        bestStreak = habit.streak.toString();
      }
    } else {
      bestStreak = habit.longestStreak.toString();
    }

    return bestStreak;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              const AutoSizeText(
                "Current streak",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                minFontSize: 12,
              ),
              Text(
                "${habit.skipped ? habit.streak : habit.completed ? habit.streak + 1 : habit.streak}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: habit.skipped
                        ? Colors.white
                        : habit.completed
                            ? theOtherColor
                            : Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              const Text(
                "Best streak",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(displayBestStreak(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: bestStreakColor())),
            ],
          ),
        ),
      ],
    );
  }
}

Widget editWidgets(
    StateSetter setState,
    BuildContext context,
    TextEditingController editcontroller,
    TextEditingController desccontroller,
    int index,
    bool dropDownChanged) {
  return Column(children: [
    //TAG

    Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            for (int i = 0; i < tagBox.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() {
                    habitTag = tagBox.getAt(i)!.tag;
                    context.read<HabitProvider>().updateSomethingEdited();
                  }),
                  onLongPress: () {
                    String? tempHabitTag = tagBox.getAt(i)!.tag;
                    if (tagBox.getAt(i)!.tag != "No tag") {
                      showDialog(
                        context: context,
                        builder: (context) => deleteTagWidget(i, context),
                      ).then((value) {
                        setState(() {
                          if (habitTag == tempHabitTag.toString()) {
                            habitTag = "No tag";
                            context
                                .read<HabitProvider>()
                                .updateSomethingEdited();
                          } else {
                            habitTag = habitTag;
                          }
                        });
                      });
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: habitTag == tagBox.getAt(i)!.tag
                            ? theOtherColor
                            : Colors.grey.shade900,
                      ),
                      height: 30,
                      child: Center(child: Text(tagBox.getAt(i)!.tag))),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  enableDrag: true,
                  builder: (context) => const AddTagWidget(),
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: theDarkGrey,
                    ),
                    height: 30,
                    child: const Center(child: Text("+"))),
              ),
            ),
          ],
        ),
      ),
    ),

    //NAME

    Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: TextFormField(
        onChanged: (value) =>
            context.read<HabitProvider>().updateSomethingEdited(),
        onSaved: (newValue) {
          editcontroller.text = newValue!;
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(35),
        ],
        cursorColor: Colors.white,
        cursorWidth: 2.0,
        cursorHeight: 22.0,
        cursorRadius: const Radius.circular(10.0),
        cursorOpacityAnimates: true,
        enableInteractiveSelection: true,
        validator: validateText,
        controller: editcontroller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: theLightColor),
          labelText: 'Habit Name',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: Colors.grey.shade900,
          suffixIcon: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IconsPage(),
                ),
              ).then((value) => setState(() {
                    updatedIcon = theIcon;
                  }));
            },
            icon: updatedIcon,
            color: Colors.white,
          ),
        ),
      ),
    ),

    //NOTES

    Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        onChanged: (value) =>
            context.read<HabitProvider>().updateSomethingEdited(),
        onSaved: (newValue) {
          desccontroller.text = newValue!;
          context.read<HabitProvider>().updateSomethingEdited();
        },
        cursorColor: Colors.white,
        cursorWidth: 2.0,
        cursorHeight: 22.0,
        cursorRadius: const Radius.circular(10.0),
        cursorOpacityAnimates: true,
        enableInteractiveSelection: true,
        controller: desccontroller,
        maxLines: 5,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          suffixIcon: const Icon(
            Icons.notes_rounded,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          labelStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: theLightColor),
          labelText: "Notes",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: Colors.grey.shade900,
        ),
      ),
    ),

    //DROPDOWN MENU

    Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AnimatedContainer(
              decoration: BoxDecoration(
                color: theDarkGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.fastOutSlowIn,
              height: context.watch<HabitProvider>().categoriesExpanded
                  ? 230.0
                  : 0.0,
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 52),
                    chooseTime("Any time", context, setState, dropDownChanged),
                    chooseTime("Morning", context, setState, dropDownChanged),
                    chooseTime("Afternoon", context, setState, dropDownChanged),
                    chooseTime("Evening", context, setState, dropDownChanged),
                  ])),
        ),
        GestureDetector(
          onTap: () => context.read<HabitProvider>().toggleExpansion(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  dropDownValue,
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(
                    context.watch<HabitProvider>().categoriesExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    ),

    const SizedBox(height: 15),

    // HABIT GOAL
    Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                context.read<HabitProvider>().updateSomethingEdited();
                if (habitGoalEdit == 1) {
                  habitGoalEdit = 0;
                  habitBox.getAt(index)!.amount = 1;
                } else {
                  amount = 2;
                  habitGoalEdit = 1;
                  habitBox.getAt(index)!.duration = 0;
                }
              });
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              fixedSize: WidgetStateProperty.all<Size>(
                  Size(MediaQuery.of(context).size.width * 0.42, 45)),
              backgroundColor: WidgetStateProperty.all<Color>(
                habitGoalEdit == 1 ? theOtherColor : Colors.grey.shade900,
              ),
            ),
            child: const Text("Number of times",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(
            width: 15,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                context.read<HabitProvider>().updateSomethingEdited();
                if (habitGoalEdit == 2) {
                  habitGoalEdit = 0;
                  habitBox.getAt(index)!.duration = 0;
                } else {
                  duration = 1;
                  habitGoalEdit = 2;
                  habitBox.getAt(index)!.amount = 1;
                }
              });
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              fixedSize: WidgetStateProperty.all<Size>(
                  Size(MediaQuery.of(context).size.width * 0.43, 45)),
              backgroundColor: WidgetStateProperty.all<Color>(
                habitGoalEdit == 2 ? theOtherColor : Colors.grey.shade900,
              ),
            ),
            child:
                const Text("Duration", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
    Visibility(
      visible: habitGoalEdit == 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SpinBox(
              cursorColor: Colors.white,
              enableInteractiveSelection: true,
              iconColor: WidgetStateProperty.all<Color>(Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                filled: true,
                fillColor: Colors.grey.shade900,
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: theLightColor),
                labelText: "Amount",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
              min: 2,
              max: 9999,
              value: amount.toDouble(),
              onChanged: (value) {
                context.read<HabitProvider>().updateSomethingEdited();
                Vibration.vibrate(duration: 10);
                setState(() => amount = value.toInt());
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              onChanged: (newValue) => setState(() {
                context.read<HabitProvider>().updateSomethingEdited();
                amountNameControllerEdit.text = newValue;
              }),
              inputFormatters: [
                LengthLimitingTextInputFormatter(35),
              ],
              cursorColor: Colors.white,
              cursorWidth: 2.0,
              cursorHeight: 22.0,
              cursorRadius: const Radius.circular(10.0),
              cursorOpacityAnimates: true,
              enableInteractiveSelection: true,
              validator: validateText,
              controller: amountNameControllerEdit,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                filled: true,
                fillColor: Colors.grey.shade900,
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: theLightColor),
                labelText: "Amount Name",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    ),

    Visibility(
      visible: habitGoalEdit == 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SpinBox(
              iconColor: WidgetStateProperty.all<Color>(Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                filled: true,
                fillColor: Colors.grey.shade900,
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: theLightColor),
                labelText: "Hours",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
              min: 0,
              max: 23,
              value: durationHours.toDouble(),
              onChanged: (value) {
                context.read<HabitProvider>().updateSomethingEdited();
                Vibration.vibrate(duration: 10);
                setState(() => durationHours = value.toInt());
              },
            ),
            const SizedBox(height: 15),
            SpinBox(
              iconColor: WidgetStateProperty.all<Color>(Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                filled: true,
                fillColor: Colors.grey.shade900,
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: theLightColor),
                labelText: "Minutes",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
              min: 0,
              max: 59,
              value: durationMinutes.toDouble(),
              onChanged: (value) {
                context.read<HabitProvider>().updateSomethingEdited();
                Vibration.vibrate(duration: 10);
                setState(() => durationMinutes = value.toInt());
              },
            ),
          ],
        ),
      ),
    ),
  ]);
}

Widget habitGoalNumber() {
  if (habitGoalEdit == 0) {
    return Container();
  } else if (habitGoalEdit == 1) {
    return Text(
      amount.toString(),
      style: const TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
  } else {
    return Column(
      children: [
        Visibility(
          visible: durationHours != 0,
          child: Text(
            "${durationHours}h",
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          visible: durationMinutes != 0,
          child: Text(
            "${durationMinutes}m",
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

Widget chooseTime(String category, BuildContext context, StateSetter setState,
    bool dropDownChanged) {
  return AnimatedOpacity(
    opacity: context.watch<HabitProvider>().categoryIsVisible ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 200),
    curve: Curves.fastOutSlowIn,
    child: Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 20),
      child: GestureDetector(
          onTap: () {
            dropDownValue = category;
            dropDownChanged = true;
            context.read<HabitProvider>().updateSomethingEdited();
            context.read<HabitProvider>().toggleExpansion();
          },
          child: Text(
            category,
            style: const TextStyle(fontSize: 16),
          )),
    ),
  );
}

String habitGoalText() {
  if (habitGoalEdit == 0) {
    return "";
  } else if (habitGoalEdit == 1) {
    return amountNameControllerEdit.text;
  } else {
    return habitGoalNumber() == "1" ? "minute" : "minutes";
  }
}
