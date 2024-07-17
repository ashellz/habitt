import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker/pages/auth/loading_page.dart';
import 'package:habit_tracker/pages/menu/settings_page.dart';
import 'package:habit_tracker/services/auth_service.dart';
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

Future<void> uploadFolderToFirebase(String folderPath, String? userId) async {
  final directory = Directory(folderPath);
  if (await directory.exists()) {
    final files = directory.listSync();
    for (var file in files) {
      if (file is File) {
        final fileName = file.path.split('/').last;
        final storageRef =
            FirebaseStorage.instance.ref().child('$userId/$fileName');
        try {
          print('Uploading file: ${file.path}');
          await storageRef.putFile(file);
          print('Successfully uploaded file: $fileName');
        } catch (e) {
          print('Failed to upload file: ${file.path}, error: $e');
        }
      }
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
    print('Directory does not exist: $folderPath');
  }
}

Future<void> backupHiveBoxesToFirebase(String? userId) async {
  if (userId == null || FirebaseAuth.instance.currentUser!.isAnonymous) {
    print('User is not authenticated');
    return;
  }

  final hiveDirectory = await getHiveBoxesDirectory();
  print('Hive directory: $hiveDirectory');
  await ensureDirectoryExists(hiveDirectory);
  await uploadFolderToFirebase(hiveDirectory, userId);
}

Future<void> restoreHiveBoxesFromFirebase(String? userId) async {
  if (userId == null) {
    print('User is not authenticated');
    return;
  }

  final storageRef = FirebaseStorage.instance.ref().child('$userId/');
  final listResult = await storageRef.listAll();
  final hiveDirectory = await getHiveBoxesDirectory();
  await ensureDirectoryExists(hiveDirectory);
  for (final item in listResult.items) {
    final file = File('$hiveDirectory/${item.name}');
    try {
      print('Downloading file: ${item.name}');
      await item.writeToFile(file);
      print('Successfully downloaded file: ${item.name}');
    } catch (e) {
      print('Failed to download file: ${item.name}, error: $e');
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
      print('Downloading file: ${item.name}');
      await item.writeToFile(file);
      print('Successfully downloaded file: ${item.name}');
    } catch (e) {
      print('Failed to download file: ${item.name}, error: $e');
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
    print('User is not authenticated');
    return;
  }

  final storageRef = FirebaseStorage.instance.ref().child('$userId/');
  final listResult = await storageRef.listAll();

  for (final item in listResult.items) {
    try {
      print('Deleting from cloud storage: ${item.name}');
      await item.delete();
      print('Successfully deleted file from cloud storage: ${item.name}');
    } catch (e) {
      print(
          'Failed to delete file from cloud storage: ${item.name}, error: $e');
    }
  }
  await AuthService().deleteAccount();
  Timer(const Duration(milliseconds: 500), () {
    Restart.restartApp();
  });
}
