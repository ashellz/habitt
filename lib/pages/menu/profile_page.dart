import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/auth_service.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:habit_tracker/util/objects/edit_profile_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    void updateUsername(changeUsernameController) {
      setState(() {
        stringBox.put('username', changeUsernameController);
      });
    }

    Future<void> updateEmail(changeEmailController, password) async {
      await AuthService()
          .updateEmail(userEmail, password, changeEmailController);
    }

    if (userEmail == '') {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You are not logged in. ',
                  style: TextStyle(fontSize: 18)),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                ),
                child: const Text("Log in?",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )
            ],
          )),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        body: ListView(
          padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Profile of",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Text(
                    stringBox.get("username")!,
                    style: TextStyle(
                      color: theLightGreen,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
                offset: const Offset(0, -15),
                child: Text(userEmail, style: const TextStyle(fontSize: 18))),
            const SizedBox(
              height: 50,
            ),

            // change username

            Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(170, 170),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: theLightGreen, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          controllerEmpty = true;
                          return editProfileDialog(
                              context, "Change username", updateUsername);
                        }).whenComplete(() => setState(() {
                          Timer(const Duration(milliseconds: 1000), () {
                            changeController.text = "";
                            passwordController.text = "";
                          });
                        })),
                    child: const Text(
                        textAlign: TextAlign.center,
                        "Change Username",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ),

                  //change email
                  /*
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(170, 170),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: theLightGreen, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          changeController.text = "";
                          controllerEmpty = true;
                          return editProfileDialog(
                              context, "Change email", updateEmail);
                        }),
                    child: const Text(
                        textAlign: TextAlign.center,
                        "Change email",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ),*/

                  // Upload data

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(170, 170),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: theLightGreen, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () {
                      backupHiveBoxesToFirebase(userId);
                    },
                    child: const Text(
                        textAlign: TextAlign.center,
                        "Upload Data",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ),

                  // delete account

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(170, 170),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: theRedColor, width: 3),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                        textAlign: TextAlign.center,
                        "Delete Account",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ),
                ]),
          ],
        ),
      );
    }
  }
}
