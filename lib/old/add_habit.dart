import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/habit/add_habit_page.dart';
import 'package:habit_tracker/old/home_page.dart';
import 'package:habit_tracker/pages/habit/icons_page.dart';

Widget addHabit(formKey, validateText, createNewHabit) {
  if (amountNameController.text.isEmpty) {
    amountNameController.text = "times";
  }
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) {
      return SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 25.0,
                    bottom: 25.0,
                  ),
                  child: Text(
                    "New Habit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    onChanged: (newValue) => mystate(() {
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IconsPage(),
                            ),
                          ).then((value) => mystate(() {
                                updatedIcon = theIcon;
                              }));
                        },
                        icon: updatedIcon,
                        color: Colors.white,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      filled: true,
                      fillColor: theGreen,
                      label: const Text(
                        "Habit Name",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      dropdownColor: theGreen,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: theGreen,
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
                        mystate(() {
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theLightGreen,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                    ),
                    child: const Text('Add Habit',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        createNewHabit();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomePage()));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
