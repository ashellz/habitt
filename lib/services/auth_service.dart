import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/loading_page.dart';
import 'package:habit_tracker/services/storage_service.dart';
import 'package:restart_app/restart_app.dart';

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
      isLoggedIn = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoadingScreen(),
        ),
      );
      await backupHiveBoxesToFirebase(userId);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()));
    } on FirebaseException catch (e) {
      errorMessage = 'An unexpected error occurred';
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
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in the user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoadingScreen(),
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
      print("Restoring Hive boxes from Firebase...");
      await restoreHiveBoxesFromFirebase(userId);
      Fluttertoast.showToast(
        msg: 'Downloading data... Please wait',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      // Wait for data restoration to complete
      while (!dataDownloaded) {
        await Future.delayed(const Duration(seconds: 1));
      }

      // Reset the flag
      dataDownloaded = false;
      isLoggedIn = true;

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
      print(e.toString());
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    isLoggedIn = false;
  }
}
