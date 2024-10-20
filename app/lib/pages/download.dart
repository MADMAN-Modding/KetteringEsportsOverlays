import 'dart:io';
import '../constants.dart' as constants;
import '../handlers/download_handler.dart';
import '../handlers/json_handler.dart';
import '../handlers/notification_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadPage();
}

class _DownloadPage extends State<DownloadPage> {
  String chosenPath = constants.Constants.executableDirectory;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Buttons for cloning and updating the repository
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: buttonAction("Download"),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: buttonAction("Update"),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        NotificationHandler.notification(
                            context, "Starting Reset...");
                        try {
                          File("${constants.Constants.executableDirectory}${constants.Constants.slashType}Esports-Logo.png")
                              .delete();
                        } catch (e) {}
                        await DownloadHandler.download(chosenPath);

                        NotificationHandler.notification(
                            context, "Overlays Reset");
                      },
                      child: const Text("Reset Overlays")),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Updates the value of the config
  void updateValue(String value) {
    chosenPath = value;
    JSONHandler().writeConfig("path", value);
    if (kDebugMode) {
      print(chosenPath);
    }
  }

  Widget buttonAction(String action) {
    return ElevatedButton(
      onPressed: () async {
        NotificationHandler.notification(context, "Starting $action...");

        await DownloadHandler.download(chosenPath);

        NotificationHandler.notification(context, "Overlays ${action}ed");
      },
      child: Text("$action Overlays"),
    );
  }
}
