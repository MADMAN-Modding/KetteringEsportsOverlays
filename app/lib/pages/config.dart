import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:falcons_esports_overlays_controller/handlers/json_handler.dart';
import 'package:filesystem_picker/filesystem_picker.dart';

// Sets up the stateful widget stuff, wahoo
class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<StatefulWidget> createState() => _ControlsPage();
}

// Class for the actual page
class _ControlsPage extends State<ConfigPage> {
  String codePath = "";

// Creates objects for the jsonHandler and for changing the text
  TextEditingController directory = TextEditingController();
  TextEditingController phpDirectory = TextEditingController();
  TextEditingController gitDirectory = TextEditingController();
  JSONHandler jsonHandler = JSONHandler();

  @override
  Widget build(BuildContext context) {
    directory.text = jsonHandler.readConfig('path');
    phpDirectory.text = jsonHandler.readConfig('phpPath');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Padding for all the elements
        // Code Directory
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                // A button with the folder icon that opens up a file-picker in order to chose the appropriate directory
                child: TextButton(
                  child: const Icon(
                    Icons.folder,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    try {
                      if (Platform.isWindows) {
                        codePath =
                            (await FilePicker.platform.getDirectoryPath())!;
                      } else {
                        // This is here until the bug on linux is fixed
                        codePath = (await FilesystemPicker.open(
                            context: context,
                            theme: FilesystemPickerTheme(
                                topBar: FilesystemPickerTopBarThemeData(
                                    backgroundColor: Colors.grey),
                                backgroundColor: Colors.grey),
                            rootDirectory: Directory("/home"),
                            contextActions: [
                              FilesystemPickerNewFolderContextAction()
                            ]))!;
                      }
                      directory.text =
                          codePath; // Sets the text equal to the path
                      jsonHandler.writeConfig('path', codePath);
                    } catch (e) {
                      return;
                    }
                  },
                ),
              ),

              // Sets the size of the textfield and also does some stuff with the controller
              SizedBox(
                width: 400,
                child: TextField(
                  controller: directory,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    hintText: 'Directory Path',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => jsonHandler.writeConfig("path", value),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "This is the directory that contains all the code",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
