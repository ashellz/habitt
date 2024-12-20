import "package:flutter/material.dart";
import "package:flutter_localization/flutter_localization.dart";
import "package:habitt/data/app_locale.dart";
import "package:habitt/pages/habit/notifications_page.dart";
import "package:habitt/pages/habit/shared%20widgets/additional_task.dart";
import "package:habitt/pages/habit/shared%20widgets/choose_tag.dart";
import "package:habitt/pages/habit/shared%20widgets/dropdown_menu.dart";
import "package:habitt/pages/habit/shared%20widgets/habit_display.dart";
import "package:habitt/pages/habit/shared%20widgets/habit_goal.dart";
import "package:habitt/pages/habit/shared%20widgets/habit_name_textfield.dart";
import "package:habitt/pages/habit/shared%20widgets/Habit%20Type/habit_type.dart";
import "package:habitt/pages/habit/shared%20widgets/notes_text_field.dart";

import "package:habitt/pages/shared%20widgets/expandable_app_bar.dart";
import "package:habitt/services/provider/color_provider.dart";
import "package:habitt/services/provider/habit_provider.dart";
import "package:habitt/util/colors.dart";

import "package:provider/provider.dart";

TextEditingController amountNameController = TextEditingController();

final formKey = GlobalKey<FormState>();

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({
    super.key,
    required this.createcontroller,
  });

  final TextEditingController createcontroller;

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  ScrollController scrollController = ScrollController();
  double scrollPosition = 0.0;
  final chooseCategoriesList = ["Any time", "Morning", "Afternoon", "Evening"];
  final TextEditingController habitTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    habitTypeController.text = "Daily";
    scrollController.addListener(() {
      setState(() {
        scrollPosition = scrollController.position.pixels;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var createcontroller = widget.createcontroller;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.watch<ColorProvider>().blackColor,
      body: Form(
        key: formKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                ExpandableAppBar(
                  actionsWidget: notificationBell(context),
                  title: AppLocale.newHabit.getString(context),
                ),
                SliverToBoxAdapter(
                  child: Column(children: [
                    HabitDisplay(
                      controller: createcontroller,
                      topPadding: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          //TAG

                          const ChooseTag(isEdit: false),

                          //NAME
                          HabitNameTextField(
                              controller: createcontroller, isEdit: false),

                          //NOTES

                          const NotesTextField(),

                          // DROPDOWN MENU
                          const DropDownMenu(),

                          // HABIT TYPE
                          const HabitType(isEdit: false),

                          // HABIT GOAL
                          const HabitGoal(
                            index: 0,
                            isEdit: false,
                          ),

                          const AdditionalTask(
                            isEdit: false,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                  ]),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.theLightColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                ),
                child: Text(AppLocale.addHabit.getString(context),
                    style: const TextStyle(color: Colors.white)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Provider.of<HabitProvider>(context, listen: false)
                        .createNewHabitProvider(createcontroller, context);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget notificationBell(BuildContext context) {
  return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const NotificationsPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      icon: const Icon(
        Icons.notifications,
        size: 30,
        color: Colors.white,
      ));
}
