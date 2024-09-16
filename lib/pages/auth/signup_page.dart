import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/auth_service.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/functions/validate_text.dart';
import 'package:restart_app/restart_app.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Welcome',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const Text('Sign up to continue',
                      style: TextStyle(fontSize: 16, color: Colors.white)),

                  //USERNAME
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      validator: validateUsername,
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      cursorColor: Colors.white,
                      cursorWidth: 2.0,
                      cursorHeight: 22.0,
                      cursorRadius: const Radius.circular(10.0),
                      cursorOpacityAnimates: true,
                      enableInteractiveSelection: true,
                      controller: _usernameController,
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
                        prefixIcon: const Icon(Icons.person_outline_rounded,
                            color: Colors.white),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),
                        labelStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white38,
                            fontWeight: FontWeight.bold),
                        labelText: "USERNAME",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                      ),
                    ),
                  ),

                  // EMAIL
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      validator: validateEmail,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      cursorColor: Colors.white,
                      cursorWidth: 2.0,
                      cursorHeight: 22.0,
                      cursorRadius: const Radius.circular(10.0),
                      cursorOpacityAnimates: true,
                      enableInteractiveSelection: true,
                      controller: _emailController,
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
                        prefixIcon: const Icon(Icons.mail_outline_rounded,
                            color: Colors.white),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),
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
                  ),

                  // PASSWORD
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      validator: validatePassword,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      cursorColor: Colors.white,
                      cursorWidth: 2.0,
                      cursorHeight: 22.0,
                      cursorRadius: const Radius.circular(10.0),
                      cursorOpacityAnimates: true,
                      enableInteractiveSelection: true,
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock_open_outlined,
                            color: Colors.white),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),
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
                    ),
                  ),

                  // SIGN UP BUTTON
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (boolBox.get("isGuest")!) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => keepDataDialog(
                                            context,
                                            _emailController,
                                            _passwordController,
                                            _usernameController));
                                  } else {
                                    signUpNewUser(
                                        context,
                                        _emailController,
                                        _passwordController,
                                        _usernameController);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                              ),
                              child: const Text(
                                'SIGN UP',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )))),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(0,
                  keyboardOpen ? MediaQuery.of(context).viewInsets.bottom : 0),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: GestureDetector(
                  onTap: () async {
                    await AuthService().signInAsGuest(context);
                  },
                  child: const Text(
                    "CONTINUE AS A GUEST",
                    style: TextStyle(color: Colors.white38, fontSize: 18),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget keepDataDialog(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController usernameController) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      side: BorderSide(color: theLightColor, width: 3.0),
    ),
    backgroundColor: Colors.black,
    title: const Center(
      child: Text(
        "Keep guest data?",
        style: TextStyle(fontSize: 22),
      ),
    ),
    actions: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ElevatedButton(
            onPressed: () async {
              signUpNewUser(context, emailController, passwordController,
                  usernameController);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(theRedColor),
            ),
            child: const Text("Delete",
                style: TextStyle(color: Colors.white, fontSize: 14))),
        ElevatedButton(
            onPressed: () async {
              keepData = true;
              await AuthService().signUp(
                  context: context,
                  email: emailController.text,
                  password: passwordController.text);
              stringBox.put('username', usernameController.text);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(theLightColor),
            ),
            child: const Text(
              "Keep",
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
      ]),
    ],
  );
}

void signUpNewUser(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController usernameController) async {
  keepData = false;
  deleteGuestHabits();
  await AuthService().signUp(
      context: context,
      email: emailController.text,
      password: passwordController.text);
  stringBox.put('username', usernameController.text);
  Restart.restartApp();
}
