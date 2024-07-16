import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:habit_tracker/util/functions/validate_text.dart';

final formKey = GlobalKey<FormState>();
TextEditingController changeController = TextEditingController();
bool controllerEmpty = true;

Widget editProfileDialog(context, title, updateUsername) {
  var validator;

  if (controllerEmpty == true) {
    if (changeController.text.isEmpty) {
      switch (title) {
        case 'Change username':
          changeController.text = stringBox.get('username')!;
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
    child: AlertDialog(
      backgroundColor: theGreen,
      title: Text(
          textAlign: TextAlign.center,
          title,
          style: const TextStyle(fontSize: 20)),
      content: SizedBox(
        width: 300,
        height: 150,
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
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 107, 138, 122),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      updateUsername(changeController.text);
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
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    ),
  );
}
