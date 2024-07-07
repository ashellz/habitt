import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;

Future<String> getApplicationDocumentsDirectoryPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> getHiveBoxesDirectory() async {
  final directoryPath = await getApplicationDocumentsDirectoryPath();
  return '$directoryPath/hive';
}

Future<void> uploadBoxToFirebase(String boxPath, String userId) async {
  final file = File(boxPath);
  final storageRef = FirebaseStorage.instance
      .ref()
      .child('$userId/${file.path.split('/').last}');
  await storageRef.putFile(file);
}

Future<void> backupHiveBoxesToFirebase(String userId) async {
  await uploadBoxToFirebase(await getHiveBoxesDirectory(), userId);
}

Future<void> restoreHiveBoxesFromFirebase(String userId) async {
  final storageRef = FirebaseStorage.instance.ref().child('$userId/');
  final listResult = await storageRef.list();
  for (final item in listResult.items) {
    final file = File('${await getHiveBoxesDirectory()}/${item.name}');
    await item.writeToFile(file);
  }
}
