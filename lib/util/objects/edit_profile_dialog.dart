import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:habit_tracker/util/functions/validate_text.dart';

final formKey = GlobalKey<FormState>();
TextEditingController changeController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool controllerEmpty = true;

Widget editProfileDialog(context, title, updateFunction) {
  var validator;
  var emailHeight = 260.0;

  if (controllerEmpty == true) {
    if (changeController.text.isEmpty) {
      switch (title) {
        case 'Change username':
          changeController.text = stringBox.get('username') ?? 'Guest';
          validator = validateUsername;
          break;
        case 'Change email':
          changeController.text = userEmail;
          validator = validateEmail;
          break;
        case 'Change password':
          changeController.text = '';
          validator = validatePassword;
          break;
      }
    }
    controllerEmpty = false;
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
          height: title == "Change email" ? emailHeight : 180,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  validator: validator,
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
                    labelStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    labelText: title == 'Change username'
                        ? "NEW USERNAME"
                        : "NEW EMAIL",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 20),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: theGreen,
                  ),
                ),
                if (title == 'Change email')
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      validator: validatePassword,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      cursorColor: Colors.white,
                      cursorWidth: 2.0,
                      cursorHeight: 22.0,
                      cursorRadius: const Radius.circular(10.0),
                      cursorOpacityAnimates: true,
                      enableInteractiveSelection: true,
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        labelText: "PASSWORD",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: theGreen,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (title == 'Change email') {
                            updateFunction(
                                changeController.text, passwordController.text);
                          } else {
                            updateFunction(changeController.text);
                          }

                          Navigator.pop(context);
                        } else {
                          mystate(() {
                            emailHeight = 300.0;
                          });
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
                        style: TextStyle(color: Colors.white),
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
