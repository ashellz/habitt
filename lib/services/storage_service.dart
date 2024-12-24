import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/tags.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/menu/profile_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/language_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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

Future<void> uploadFolderToFirebase(String folderPath, String? userId,
    bool isDaily, BuildContext context) async {
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
      if (kDebugMode) {
        print(e);
      }
    }
    uploadButtonEnabled = true;
    Fluttertoast.showToast(
      msg: AppLocale.dataUploaded.getString(context),
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

Future<void> backupHiveBoxesToFirebase(
    String? userId, bool isDaily, BuildContext context) async {
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
  await uploadFolderToFirebase(hiveDirectory, userId, isDaily, context);
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
      if (!item.name.contains('acessToken')) {
        if (kDebugMode) {
          print('Downloading file: ${item.name}');
        }
        await item.writeToFile(file);
        if (kDebugMode) {
          print('Successfully downloaded file: ${item.name}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to download file: ${item.name}, error: $e');
      }
    }
  }
  dataDownloaded = true;
}

void addInitialData(BuildContext context) {
  String languageCode =
      Provider.of<LanguageProvider>(context, listen: false).languageCode;

  List initialHabits = [
    HabitData(
        name: languageCode == 'en' ? 'Open the app' : 'Otvoriti aplikaciju',
        notes: languageCode == 'en'
            ? 'Open the app for the first time'
            : 'Otvoriti aplikaciju po prvi put',
        category: 'Any time',
        streak: 0,
        completed: true,
        icon: "Icons.door_front_door_rounded",
        amount: 1,
        amountName: languageCode == 'en' ? "times" : "puta",
        amountCompleted: 1,
        duration: 0,
        durationCompleted: 0,
        skipped: false,
        tag: "No tag",
        notifications: List.empty(),
        longestStreak: 0,
        id: 0,
        task: false,
        type: "Daily",
        weekValue: 0,
        monthValue: 0,
        customValue: 0,
        selectedDaysAWeek: [],
        selectedDaysAMonth: [],
        customAppearance: [],
        timesCompletedThisWeek: 0,
        timesCompletedThisMonth: 0,
        paused: false,
        lastCustomUpdate: DateTime.now()),
    HabitData(
        name: languageCode == 'en' ? 'Add a new habit' : 'Dodati novu naviku',
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
        task: false,
        type: "Daily",
        weekValue: 0,
        monthValue: 0,
        customValue: 0,
        selectedDaysAWeek: [],
        selectedDaysAMonth: [],
        customAppearance: [],
        timesCompletedThisWeek: 0,
        timesCompletedThisMonth: 0,
        paused: false,
        lastCustomUpdate: DateTime.now())
  ];

  if (tagBox.isEmpty) {
    List<String> tagsList =
        Provider.of<DataProvider>(context, listen: false).tagsList;

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

// UPLOAD TO GOOGLE DRIVE

// Function to upload a folder to Google Drive
Future<void> uploadFolderToGoogleDrive(
    bool isDaily, BuildContext context) async {
  String accessToken =
      accessTokenBox.get('accessToken') ?? 'failed access token';
  print(accessToken);
  var folderPath = await getHiveBoxesDirectory();

  final directory = Directory(folderPath);
  if (await directory.exists()) {
    final files = directory.listSync();

    // Step 1: Get or create the "habit_data" folder in Google Drive
    String folderId = await getOrCreateFolder(accessToken, "habit_data");

    try {
      for (var file in files) {
        if (file is File) {
          final fileName = file.path.split('/').last;
          try {
            if (kDebugMode) {
              print('Uploading file: ${file.path}');
            }
            if (isDaily) {
              if (!fileName.contains('accessToken')) {
                await uploadFileToDrive(
                    accessToken, file.path, fileName, folderId);
              }
            } else if (fileName.contains('habit') ||
                fileName.contains('tag') ||
                fileName.contains('streak')) {
              await uploadFileToDrive(
                  accessToken, file.path, fileName, folderId);
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

    // Show success message
    Fluttertoast.showToast(
      msg: AppLocale.dataUploaded.getString(context),
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

// Function to get or create a folder in Google Drive
Future<String> getOrCreateFolder(String accessToken, String folderName) async {
  // Search for the folder by name
  final searchUrl =
      'https://www.googleapis.com/drive/v3/files?q=name="$folderName" and mimeType="application/vnd.google-apps.folder"';

  final searchResponse = await http.get(
    Uri.parse(searchUrl),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (searchResponse.statusCode == 200) {
    final searchResult = json.decode(searchResponse.body);
    if (searchResult['files'].isNotEmpty) {
      // Return the existing folder ID
      return searchResult['files'][0]['id'];
    }
  }

  // If the folder doesn't exist, create it
  const createFolderUrl = 'https://www.googleapis.com/drive/v3/files';
  final folderMetadata = json.encode({
    'name': folderName,
    'mimeType': 'application/vnd.google-apps.folder',
  });

  final createResponse = await http.post(
    Uri.parse(createFolderUrl),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: folderMetadata,
  );

  // Enhanced error handling
  if (createResponse.statusCode != 200) {
    print(
        'Failed to create folder: ${createResponse.statusCode}, ${createResponse.body}');
    throw Exception('Failed to create folder: ${createResponse.statusCode}');
  }

  final createdFolder = json.decode(createResponse.body);
  return createdFolder['id']; // Return the new folder ID
}

// Function to upload a file to Google Drive
Future<void> uploadFileToDrive(String accessToken, String filePath,
    String fileName, String folderId) async {
  const url =
      'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart';

  final fileBytes = await File(filePath).readAsBytes();

  // Create metadata
  final metadata = json.encode({
    'name': fileName,
    'parents': [folderId],
  });

  // Create a MultipartRequest
  final http.MultipartRequest request =
      http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..headers['Content-Type'] =
            'multipart/related; boundary=foo_bar_baz' // Set boundary
        ..fields['metadata'] = metadata // Add metadata
        ..files.add(http.MultipartFile.fromBytes('data', fileBytes,
            filename: fileName)); // Add file data

  // Send the request
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  // Check response status
  if (response.statusCode == 200) {
    print('File uploaded successfully: ${response.body}');
  } else {
    print('Error uploading file: ${response.statusCode}, ${response.body}');
  }
}
