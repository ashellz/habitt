import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/util/functions/validate_text.dart';

final formKey = GlobalKey<FormState>();
TextEditingController changeController = TextEditingController();
TextEditingController passwordController = TextEditingController();

Widget editProfileDialog(context, title, updateFunction) {
  if (changeController.text.isEmpty) {
    changeController.text = stringBox.get('username') ?? 'Guest';
  }

  return Form(
    key: formKey,
    child: StatefulBuilder(
      builder: (BuildContext context, StateSetter mystate) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          side: BorderSide(color: theLightGreen, width: 3.0),
        ),
        backgroundColor: Colors.black,
        content: SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: validateUsername,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  cursorColor: Colors.white,
                  cursorWidth: 2.0,
                  cursorHeight: 22.0,
                  cursorRadius: const Radius.circular(10.0),
                  cursorOpacityAnimates: true,
                  enableInteractiveSelection: true,
                  controller: changeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 20),
                    labelStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white38,
                        fontWeight: FontWeight.bold),
                    labelText: "NEW USERNAME",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          updateFunction(changeController.text);

                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        fixedSize:
                            WidgetStateProperty.all<Size>(const Size(150, 50)),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(theLightGreen),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
