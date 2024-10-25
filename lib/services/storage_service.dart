import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/tags.dart';
import 'package:habitt/pages/auth/loading_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/menu/profile_page.dart';
import 'package:habitt/services/auth_service.dart';

import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';

String? userId = FirebaseAuth.instance.currentUser?.uid;
String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
bool dataDownloaded = false;

Future<String> getApplicationDocumentsDirectoryPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> getHiveBoxesDirectory() async {
  final directoryPath = await getApplicationDocumentsDirectoryPath();
  return '$directoryPath/hive_folder';
}

Future<void> ensureDirectoryExists(String path) async {
  final directory = Directory(path);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
}

Future<void> uploadFolderToFirebase(
    String folderPath, String? userId, bool isDaily) async {
  final directory = Directory(folderPath);
  if (await directory.exists()) {
    final files = directory.listSync();

    try {
      for (var file in files) {
        if (file is File) {
          final fileName = file.path.split('/').last;
          final storageRef =
              FirebaseStorage.instance.ref().child('$userId/$fileName');
          try {
            if (kDebugMode) {
              print('Uploading file: ${file.path}');
            }
            if (isDaily) {
              await storageRef.putFile(file);
            } else if (fileName.contains('habit') ||
                fileName.contains('tag') ||
                fileName.contains('streak')) {
              await storageRef.putFile(file);
            }
            if (kDebugMode) {
              print('Successfully uploaded file: $fileName');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Failed to upload file: ${file.path}, error: $e');
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
    uploadButtonEnabled = true;
    Fluttertoast.showToast(
      msg: 'Data uploaded',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  } else {
    if (kDebugMode) {
      print('Directory does not exist: $folderPath');
    }
  }
}

Future<void> backupHiveBoxesToFirebase(String? userId, bool isDaily) async {
  if (userId == null || FirebaseAuth.instance.currentUser!.isAnonymous) {
    if (kDebugMode) {
      print('User is not authenticated');
    }
    return;
  }

  final hiveDirectory = await getHiveBoxesDirectory();
  if (kDebugMode) {
    print('Hive directory: $hiveDirectory');
  }
  await ensureDirectoryExists(hiveDirectory);
  await uploadFolderToFirebase(hiveDirectory, userId, isDaily);
}

Future<void> restoreHiveBoxesFromFirebase(String? userId) async {
  if (userId == null) {
    if (kDebugMode) {
      print('User is not authenticated');
    }
    return;
  }

  final storageRef = FirebaseStorage.instance.ref().child('$userId/');
  final listResult = await storageRef.listAll();
  final hiveDirectory = await getHiveBoxesDirectory();
  await ensureDirectoryExists(hiveDirectory);
  for (final item in listResult.items) {
    final file = File('$hiveDirectory/${item.name}');
    try {
      if (kDebugMode) {
        print('Downloading file: ${item.name}');
      }
      await item.writeToFile(file);
      if (kDebugMode) {
        print('Successfully downloaded file: ${item.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to download file: ${item.name}, error: $e');
      }
    }
  }
  dataDownloaded = true;
}

Future<void> newAccountDownloadData(BuildContext context) async {
  final storageRef = FirebaseStorage.instance.ref().child('new_account/');
  final listResult = await storageRef.listAll();
  final hiveDirectory = await getHiveBoxesDirectory();
  await ensureDirectoryExists(hiveDirectory);

  for (final item in listResult.items) {
    final file = File('$hiveDirectory/${item.name}');
    try {
      if (kDebugMode) {
        print('Downloading file: ${item.name}');
      }
      await item.writeToFile(file);
      if (kDebugMode) {
        print('Successfully downloaded file: ${item.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to download file: ${item.name}, error: $e');
      }
    }
  }
  dataDownloaded = true;
  Restart.restartApp();
}

Future<void> deleteUserCloudStorage(context) async {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) =>
          const LoadingScreen(text: "Deleting account...")));

  if (userId == null) {
    if (kDebugMode) {
      print('User is not authenticated');
    }
    return;
  }

  final storageRef = FirebaseStorage.instance.ref().child('$userId/');
  final listResult = await storageRef.listAll();

  for (final item in listResult.items) {
    try {
      if (kDebugMode) {
        print('Deleting from cloud storage: ${item.name}');
      }
      await item.delete();
      if (kDebugMode) {
        print('Successfully deleted file from cloud storage: ${item.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'Failed to delete file from cloud storage: ${item.name}, error: $e');
      }
    }
  }
  await AuthService().deleteAccount();
  Timer(const Duration(milliseconds: 500), () {
    Restart.restartApp();
  });
}

Future<void> deleteGuestHabits() async {
  final hiveDirectory = await getHiveBoxesDirectory();
  await ensureDirectoryExists(hiveDirectory);

  final directory = Directory(hiveDirectory);

  List<String> keywords = ['habits.', 'habitdata.', 'tag'];

  if (await directory.exists()) {
    final files = directory.listSync();

    for (final file in files) {
      if (file is File) {
        if (keywords.any((keyword) => file.path.contains(keyword))) {
          file.deleteSync();
        }
      }
    }
  }

  dataDownloaded = true;
}

void addInitialData() {
  List initialHabits = [
    HabitData(
        name: 'Open the app',
        notes: 'Open the app for the first time',
        category: 'Any time',
        streak: 0,
        completed: true,
        icon: "Icons.door_front_door_rounded",
        amount: 1,
        amountName: "times",
        amountCompleted: 1,
        duration: 0,
        durationCompleted: 0,
        skipped: false,
        tag: "No tag",
        notifications: List.empty(),
        longestStreak: 0,
        id: 0,
        task: false),
    HabitData(
        name: 'Add a new habit',
        notes: '',
        category: 'Any time',
        streak: 0,
        completed: false,
        icon: "Icons.add",
        amount: 1,
        amountName: "times",
        amountCompleted: 0,
        duration: 0,
        durationCompleted: 0,
        skipped: false,
        tag: "No tag",
        notifications: List.empty(),
        longestStreak: 0,
        id: 1,
        task: false)
  ];

  if (tagBox.isEmpty) {
    for (int i = 0; i < tagsList.length; i++) {
      tagBox.add(TagData(tag: tagsList[i]));
    }
  }

  if (habitBox.isEmpty) {
    for (int i = 0; i < initialHabits.length; i++) {
      habitBox.add(initialHabits[i]);
    }
  }
}
