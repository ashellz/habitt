import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/auth/loading_page.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/services/auth_service.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:habit_tracker/util/functions/validate_text.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 67, 54),
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
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded,
                            color: Colors.white),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white38,
                            fontWeight: FontWeight.bold),
                        labelText: "USERNAME",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 107, 138, 122),
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
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline_rounded,
                            color: Colors.white),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white38,
                            fontWeight: FontWeight.bold),
                        labelText: "EMAIL",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: "example@mail.com",
                        hintStyle: TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Color.fromARGB(255, 107, 138, 122),
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
                      decoration: const InputDecoration(
                        prefixIcon:
                            Icon(Icons.lock_open_outlined, color: Colors.white),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                        labelStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white38,
                            fontWeight: FontWeight.bold),
                        labelText: "PASSWORD",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 107, 138, 122),
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
                                  await AuthService().signUp(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text);
                                  stringBox.put(
                                      'username', _usernameController.text);
                                }
                                newAccountDownloadData(context);
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
                                    fontWeight: FontWeight.bold),
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
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: GestureDetector(
                onTap: () async {
                  await AuthService().signInAnonimusly();
                  boolBox.put("isGuest", true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoadingScreen(
                        text: "Loading data...",
                      ),
                    ),
                  );
                  newAccountDownloadData(context);
                },
                child: const Text(
                  "CONTINUE AS A GUEST",
                  style: TextStyle(color: Colors.white38, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
