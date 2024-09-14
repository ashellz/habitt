import "package:flutter/material.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/functions/buildEditedValues.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/pages/edit_page.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/widgets/popup_button.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/widgets/save_button.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/pages/stats_page.dart";
import "package:habit_tracker/pages/habit/Shared%20Widgets/habit_display.dart";
import "package:habit_tracker/services/provider/habit_provider.dart";
import "package:habit_tracker/util/colors.dart";
import "package:provider/provider.dart";

int habitGoalEdit = 0;

bool updated = false;
bool dropDownChanged = false;

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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, actions: [
        PopUpButton(widget: widget, editcontroller: editcontroller),
      ]),
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
                  HabitDisplay(
                    controller: editcontroller,
                    topPadding: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //PAGE VIEW
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
                              ? statsPage(context, widget.index)
                              : editPage(
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

            // SAVE BUTTON
            SaveButton(
                keyboardOpen: keyboardOpen,
                widget: widget,
                editcontroller: editcontroller),
          ],
        ),
      ),
    ));
  }
}
