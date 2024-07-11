import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:habit_tracker/pages/home_page.dart";
import "package:habit_tracker/pages/icons_page.dart";
import "package:numberpicker/numberpicker.dart";
import 'package:habit_tracker/util/functions/validate_text.dart';

int habitGoal = 0;
int currentAmountValue = 2;
int currentDurationValue = 1;

TextEditingController amountNameController = TextEditingController();

final formKey = GlobalKey<FormState>();

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key, required this.createNewHabit});

  final Function createNewHabit;

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  @override
  Widget build(BuildContext context) {
    Color theLightGreen = const Color.fromARGB(255, 62, 80, 71);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 25.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    "New Habit",
                    style: TextStyle(
                      fontSize: 32.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ICON
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      color: theLightGreen,
                    ),
                    child: Row(
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: IconButton(
                                iconSize: 80,
                                onPressed: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const IconsPage()))
                                    .then((value) => setState(() {
                                          updatedIcon = theIcon;
                                        })),
                                icon: updatedIcon,
                                color: Colors.white,
                              ),
                            ),

                            //TEXT
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  truncatedText(context),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  dropDownValue,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 45, right: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "15",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "minutes",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )

                //NAME
                ,
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 20, bottom: 15),
                  child: TextFormField(
                    onChanged: (newValue) => setState(() {
                      createcontroller.text = newValue;
                    }),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(35),
                    ],
                    validator: validateText,
                    controller: createcontroller,
                    cursorColor: Colors.white,
                    cursorWidth: 2.0,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      filled: true,
                      fillColor: theLightGreen,
                      label: const Text(
                        "Habit Name",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // DROPDOWN MENU
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      dropdownColor: theLightGreen,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: theLightGreen,
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      hint: const Text("Any Time",
                          style: TextStyle(color: Colors.white)),
                      items: dropdownItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

String truncatedText(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  int maxLength;

  if (screenWidth < 300) {
    maxLength = 5; // very small screen
  } else if (screenWidth < 400) {
    maxLength = 8; // small screen
  } else if (screenWidth < 500) {
    maxLength = 12; // medium screen
  } else {
    maxLength = 20; // larger screen
  }

  String name = createcontroller.text;
  if (name.length > maxLength) {
    return '${name.substring(0, maxLength)}...';
  }
  return name;
}
