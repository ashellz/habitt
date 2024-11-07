import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitt/pages/auth/loading_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/storage_service.dart';
import 'package:restart_app/restart_app.dart';

bool passwordIncorrect = false;
late String errorMessage;

bool isLoggedIn = boolBox.get('isLoggedIn') ?? false;

class AuthService {
  User? user;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'https://www.googleapis.com/auth/drive.file',
        ],
      ).signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      accessTokenBox.put('accessToken', googleAuth.accessToken!);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      user = userCredential.user;

      String username = stringBox.get('username') ?? "Guest";

      if (username == "Guest") {
        stringBox.put('username', user!.displayName!);
      }

      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // The user is new
        metadataBox.put("dayJoined", DateTime.now());
        boolBox.put("firstTimeOpened", true);
      }

      if (context.mounted) {
        getIntoTheApp(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        Fluttertoast.showToast(
          msg:
              'An account with that email is signed in with a different credential.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      }
    }
  }

  Future<void> signOut(context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => const LoadingScreen(
                text: "Signing out...",
              )),
    );
    await FirebaseAuth.instance.signOut();
    isLoggedIn = false;
    userId = null;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const HomePage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  getIntoTheApp(BuildContext context) async {
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
    await restoreHiveBoxesFromFirebase(userId).then((_) async {
      Restart.restartApp();
    });
  }
}

/*
  Future<void> updateEmail(
      String email, String password, String newEmail) async {
    await reauthenticateUser(email, password);
    await changeEmail(newEmail);
    userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  }*/

