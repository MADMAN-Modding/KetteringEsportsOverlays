import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart' as constants;

class DownloadHandler {
  static download(String path) async {
    String slashType = constants.Constants.slashType;

    if (!Platform.isAndroid || await Permission.storage.request().isGranted) {
      await http
          .get(Uri.https('codeload.github.com',
              '/MADMAN-Modding/KetteringEsportsOverlays/zip/refs/heads/main'))
          .then((response) {
        File("$path${slashType}overlay.zip")
            .writeAsBytesSync(response.bodyBytes);
      });

      // Extract stff
      extractor(path);

      // Delete Stuff
      File("$path${slashType}overlay.zip").deleteSync();

      // Try to delete the directory if its already there
      try {
        Directory("$path${slashType}KetteringEsportsOverlays")
            .deleteSync(recursive: true);
      } catch (e) {}

      // Remove the app dir cause it isn't needed
      try {
        Directory(
                "$path${slashType}KetteringEsportsOverlays-main${slashType}app")
            .deleteSync(recursive: true);
      } catch (e) {}

      // Makes a new image file and then overwrites it if it didn't already exist
      if (!File("$path${slashType}Esports-Logo.png").existsSync()) {
        // Makes the new file
        FileImage(File("$path${slashType}Esports-Logo.png"))
            .file
            .writeAsBytesSync(FileImage(File(
                    "$path${slashType}KetteringEsportsOverlays-main${slashType}images${slashType}Esports-Logo.png"))
                .file
                .readAsBytesSync());
      }

      // Overwrites the downloaded logo
      FileImage(File(
              "$path${slashType}KetteringEsportsOverlays-main${slashType}images${slashType}Esports-Logo.png"))
          .file
          .writeAsBytesSync(FileImage(File(
                  "$path${slashType}KetteringEsportsOverlays-main${slashType}images${slashType}Esports-Logo.png"))
              .file
              .readAsBytesSync());
    }
  }

  static extractor(String path) {
    String slashType = constants.Constants.slashType;

    extractFileToDisk("$path${slashType}overlay.zip", path);
  }
}
