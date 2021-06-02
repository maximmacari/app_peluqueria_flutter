import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:path_provider/path_provider.dart";
import 'package:permission_handler/permission_handler.dart';

Future<Directory> get internalAppDirectory async =>
    // Retrieve "External Storage Directory" for Android and "NSApplicationSupportDirectory" for iOS
    Platform.isAndroid
        ? await getApplicationSupportDirectory() //getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

Future<bool> fileExists(String path) async {
  return await File(path).exists();
}

writeFileAsString(String filePath, String jsonEncodedContent) async {
  try {
    File file = File(filePath);
    // Convert json object to String data using json.encode() method

    await file.writeAsString(jsonEncodedContent.toString());
    print("File created, with: ${jsonEncodedContent.toString()}");
  } catch (err) {
    print("err ${err.toString()}");
  }
}

Future<String> readFileAsString(String filePath) async {
  String fileContent = "";
  try {
    fileContent = await File(filePath).readAsString();
  } catch (err) {
    print("err ${err.toString()}");
  }
  return fileContent;
}

  Future<PermissionStatus> reqPermissions(context) async {
    var status = await Permission.storage.request();
    if (!status.isDenied && !status.isGranted) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Permisio de almacenamiento.'),
                content: Text(
                    'Necesitamos tu permiso para mejorar el rendimiento de la app.'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Denegar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Ajustes'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    }
    return status;
  }
