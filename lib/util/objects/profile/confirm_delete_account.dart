import 'package:flutter/material.dart';
import 'package:habit_tracker/services/auth_service.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:habit_tracker/util/colors.dart';

bool confirmAgain = false;
TextEditingController emailControllerConfirm = TextEditingController();
TextEditingController passwordControllerConfirm = TextEditingController();

Widget confirmDeleteAccount() {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: theRedColor, width: 3.0),
      ),
      backgroundColor: Colors.black,
      title: Text(
        textAlign: TextAlign.center,
        confirmAgain
            ? "This will delete all your account data."
            : 'Are you sure you want to delete your account?',
        style: const TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    backgroundColor: WidgetStatePropertyAll(theRedColor)),
                onPressed: () {
                  if (confirmAgain) {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => reauthenticateUser(context));
                  } else {
                    mystate(() {
                      confirmAgain = true;
                    });
                  }
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
            OutlinedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: theRedColor,
                      width: 3.0,
                    )),
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
          ],
        )
      ],
    ),
  );
}

Widget reauthenticateUser(context) {
  bool hidePass = true;
  IconData hidePassIcon = Icons.visibility_off_rounded;
  Color hidePassColor = Colors.grey.shade800;

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: theRedColor, width: 3.0),
      ),
      backgroundColor: Colors.black,
      title: const Text(
        textAlign: TextAlign.center,
        "Reauthenticate to delete account.",
        style: TextStyle(fontSize: 20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // EMAIL
          TextFormField(
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            cursorColor: Colors.white,
            cursorWidth: 2.0,
            cursorHeight: 22.0,
            cursorRadius: const Radius.circular(10.0),
            cursorOpacityAnimates: true,
            enableInteractiveSelection: true,
            controller: emailControllerConfirm,
            keyboardType: TextInputType.emailAddress,
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
              prefixIcon:
                  const Icon(Icons.mail_outline_rounded, color: Colors.white),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              labelStyle: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white38,
                  fontWeight: FontWeight.bold),
              labelText: "EMAIL",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.black),
              ),
              hintText: "example@mail.com",
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.grey.shade900,
            ),
          ),
          // PASSWORD
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: StatefulBuilder(builder: (context, StateSetter setState) {
              return TextFormField(
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                cursorColor: Colors.white,
                cursorWidth: 2.0,
                cursorHeight: 22.0,
                cursorRadius: const Radius.circular(10.0),
                cursorOpacityAnimates: true,
                enableInteractiveSelection: true,
                controller: passwordControllerConfirm,
                obscureText: hidePass,
                keyboardType: TextInputType.visiblePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (hidePass) {
                              hidePass = false;
                              hidePassIcon = Icons.visibility_rounded;
                              hidePassColor = Colors.white;
                            } else {
                              hidePass = true;
                              hidePassIcon = Icons.visibility_off_rounded;
                              hidePassColor = Colors.grey.shade800;
                            }
                          });
                        },
                        icon: Icon(
                          hidePassIcon,
                          color: hidePassColor,
                        )),
                  ),
                  prefixIcon:
                      const Icon(Icons.lock_open_outlined, color: Colors.white),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  labelStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white38,
                      fontWeight: FontWeight.bold),
                  labelText: "PASSWORD",
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                ),
              );
            }),
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(120, 50),
                    ),
                    backgroundColor: WidgetStatePropertyAll(theRedColor)),
                onPressed: () async {
                  await AuthService().reauthenticateUser(
                      emailControllerConfirm.text,
                      passwordControllerConfirm.text);
                  if (!passwordIncorrect) {
                    emailControllerConfirm.clear();
                    passwordControllerConfirm.clear();
                    deleteUserCloudStorage(context);
                  }
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
            OutlinedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(120, 50),
                    ),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: theRedColor,
                      width: 3.0,
                    )),
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
          ],
        )
      ],
    ),
  );
}
