import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/icons_page.dart';

Widget addHabit(formKey, validateText, createNewTask) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) {
      return SizedBox(
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
                  bottom: 10.0,
                ),
                child: Text(
                  "New Habit",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  validator: validateText,
                  controller: createcontroller,
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
                    ),
                    labelStyle: const TextStyle(fontSize: 16.0),
                    labelText: "Habit Name",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(
                        255, 183, 181, 151), // Added background color
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    dropdownColor: const Color.fromARGB(255, 218, 211, 190),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 218, 211, 190),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    hint: const Text("Any Time"),
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      //setState(() {
                      dropDownValue = newValue!;
                      //});
                    },
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20.0,
                      bottom: 20.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          createNewTask();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
                        shape: const StadiumBorder(),
                        minimumSize:
                            const Size(120, 50), // Increase button size
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
