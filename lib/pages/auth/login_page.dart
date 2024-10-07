import 'package:flutter/material.dart';
import 'package:habitt/pages/auth/signup_page.dart';
import 'package:habitt/services/auth_service.dart';
import 'package:habitt/util/functions/validate_text.dart';
import 'package:icons_plus/icons_plus.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool hidePass = true;
  IconData hidePassIcon = Icons.visibility_off_rounded;
  Color hidePassColor = Colors.grey.shade800;

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
                  const Text('Sign in to continue',
                      style: TextStyle(fontSize: 16, color: Colors.white)),

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
                    child: StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return TextFormField(
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
                                      hidePassIcon =
                                          Icons.visibility_off_rounded;
                                      hidePassColor = Colors.grey.shade800;
                                    }
                                  });
                                },
                                icon: Icon(
                                  hidePassIcon,
                                  color: hidePassColor,
                                )),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade900,
                        ),
                      );
                    }),
                  ), // SIGN IN BUTTON
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await AuthService().signIn(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text);
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
                                'SIGN IN',
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
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text("or continue with",
                      style: TextStyle(color: Colors.grey)),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SignInMethod(
                        icon: Bootstrap.google,
                        signInFunction: AuthService().signInWithGoogle),
                    SignInMethod(
                        icon: Bootstrap.github,
                        signInFunction: AuthService().signInWithGitHub),
                  ]),
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
                    style: TextStyle(color: Colors.grey, fontSize: 18),
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
