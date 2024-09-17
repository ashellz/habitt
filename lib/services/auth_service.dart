import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracker/pages/auth/loading_page.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/auth/signup_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:restart_app/restart_app.dart';

bool passwordIncorrect = false;
late String errorMessage;

bool isLoggedIn = boolBox.get('isLoggedIn') ?? false;

class AuthService {
  Future<void> signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (keepData) {
        boolBox.put("isGuest", false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const NewHomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const NewHomePage(),
          ),
        );
      }

      isLoggedIn = true;
    } on FirebaseException catch (e) {
      errorMessage = 'An unexpected error occurred.';

      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account with that email already exists.';
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      if (errorMessage == 'An unexpected error occurred') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => SignupPage(),
          ),
        );
      }
    }
  }

  int signInCounter = 0;

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    signInCounter++;
    try {
      // Sign in the user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              const LoadingScreen(text: "Signing in..."),
        ),
      );
      // Ensure user is authenticated before accessing userId
      userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw FirebaseAuthException(
          code: 'user-not-authenticated',
          message: 'User is not authenticated',
        );
      }

      // Restore Hive boxes from Firebase
      if (kDebugMode) {
        print("Restoring Hive boxes from Firebase...");
      }
      await restoreHiveBoxesFromFirebase(userId);
      // Wait for data restoration to complete
      while (!dataDownloaded) {
        await Future.delayed(const Duration(seconds: 1));
      }

      // Reset the flag
      dataDownloaded = false;
      isLoggedIn = true;

      signInCounter = 0;
      await Restart.restartApp();

      // Navigate to HomePage
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(),
        ),
      );*/
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'The email or password is incorrect';
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'The password is incorrect';
      }
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      await FirebaseAuth.instance.signOut().then(
        (value) {
          if (signInCounter < 3) {
            signIn(email: email, password: password, context: context);
          }
        },
      );

      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> signInAsGuest(BuildContext context) async {
    await signInAnonimusly();
    if (boolBox.get("isGuest")!) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const NewHomePage(),
        ),
      );
    } else {
      boolBox.put("isGuest", true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoadingScreen(
            text: "Loading data...",
          ),
        ),
      );

      stringBox.put("username", "Guest");
      deleteGuestHabits().then((value) {
        Restart.restartApp();
      });
    }
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGitHub() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    final credential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInAnonimusly() async {
    await FirebaseAuth.instance.signInAnonymously();
    isLoggedIn = true;
  }

  Future<void> signOut(context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => const LoadingScreen(
                text: "Signing out...",
              )),
    );
    await backupHiveBoxesToFirebase(userId);
    await FirebaseAuth.instance.signOut();
    isLoggedIn = false;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    );
  }

  Future<void> deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
      if (kDebugMode) {
        print("Account deleted successfully");
      }
    }
  }

  /*

  Future<void> changeEmail(String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updateEmail(newEmail);
        print("Email updated successfully");
      } catch (e) {
        print("Failed to update email: $e");
      }
    }
  }
*/
  Future<void> reauthenticateUser(String email, String password) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      try {
        await user.reauthenticateWithCredential(credential);
        passwordIncorrect = false;
        if (kDebugMode) {
          print("User re-authenticated");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Failed to re-authenticate user: $e");
        }
        passwordIncorrect = true;
        Fluttertoast.showToast(
          msg: 'Password incorrect',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    }
  }
/*
  Future<void> updateEmail(
      String email, String password, String newEmail) async {
    await reauthenticateUser(email, password);
    await changeEmail(newEmail);
    userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  }*/
}
