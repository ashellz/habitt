import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitt/pages/auth/login_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/auth_service.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/storage_service.dart';
import 'package:habitt/util/functions/validate_text.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

// ignore: must_be_immutable
class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool hidePass = true;
  IconData hidePassIcon = Icons.visibility_off_rounded;
  Color hidePassColor = Colors.grey.shade800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<ColorProvider>().blackColor,
      appBar:
          AppBar(backgroundColor: context.watch<ColorProvider>().blackColor),
      body: Padding(
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
                  keyboardAppearance:
                      Theme.of(context).brightness == Brightness.dark
                          ? Brightness.dark
                          : Brightness.light,
                  validator: validateUsername,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                          color: context.watch<ColorProvider>().blackColor),
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
                    border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                          color: context.watch<ColorProvider>().blackColor),
                    ),
                    filled: true,
                    fillColor: context.watch<ColorProvider>().greyColor,
                  ),
                ),
              ),

              // EMAIL
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  keyboardAppearance:
                      Theme.of(context).brightness == Brightness.dark
                          ? Brightness.dark
                          : Brightness.light,
                  validator: validateEmail,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                          color: context.watch<ColorProvider>().blackColor),
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
                    border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(
                          color: context.watch<ColorProvider>().blackColor),
                    ),
                    hintText: "example@mail.com",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: context.watch<ColorProvider>().greyColor,
                  ),
                ),
              ),

              // PASSWORD
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child:
                    StatefulBuilder(builder: (context, StateSetter setState) {
                  return TextFormField(
                    textInputAction: TextInputAction.done,
                    validator: validatePassword,
                    keyboardAppearance:
                        Theme.of(context).brightness == Brightness.dark
                            ? Brightness.dark
                            : Brightness.light,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                      prefixIcon: const Icon(Icons.lock_open_outlined,
                          color: Colors.white),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      labelStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white38,
                          fontWeight: FontWeight.bold),
                      labelText: "PASSWORD",
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                            color: context.watch<ColorProvider>().blackColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                            color: context.watch<ColorProvider>().blackColor),
                      ),
                      filled: true,
                      fillColor: context.watch<ColorProvider>().greyColor,
                    ),
                  );
                }),
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
                                keepData = true;
                                await AuthService().signUp(
                                    context: context,
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                stringBox.put(
                                    'username', _usernameController.text);
                              } else {
                                signUpNewUser(context, _emailController,
                                    _passwordController, _usernameController);
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
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const Text("or continue with",
                  style: TextStyle(color: Colors.grey)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInMethod(
                      icon: Bootstrap.google,
                      signInFunction: AuthService().signInWithGoogle),
                  SignInMethod(
                      icon: Bootstrap.github,
                      signInFunction: AuthService().signInWithGitHub),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInMethod extends StatelessWidget {
  const SignInMethod({
    super.key,
    required this.icon,
    required this.signInFunction,
  });

  final IconData icon;
  final Future<void> Function(BuildContext context) signInFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: IconButton(
            onPressed: () async {
              await signInFunction(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.watch<ColorProvider>().greyColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
            icon: Icon(icon, color: Colors.white38, size: 25)));
  }
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
