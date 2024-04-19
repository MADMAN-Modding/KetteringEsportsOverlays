import 'dart:io';
import 'package:json_file/json_file.dart';

class JSONHandler {
  // 
  var overlayJSONData = {};
  var overlayFile;
  var overlayJSONString;

  // Controller config variables
  var configJSON;

  JSONHandler () {
    // Try-catch to read config values
    try {
      configJSON = File('config.json').readAsJsonSync();
    } catch (e) {
      print("Can't find file :( $e \nmaking a new config");
      File('config.json').create(recursive: true);

      File('config.json').writeAsString(
        '''{\n  "path": "."\n}'''
      );

      configJSON = File('config.json').readAsJsonSync();
      
    }
  }

  // Overlay methods
  Map fullOutputOverlay() {
    return overlayJSONData;
  }

  void writeOverlay(String key, String data) {
    var fileWrite = overlayFile.openWrite();

    fileWrite.write('{"$key": "$data"}');
  }

  String readOverlay(String key) {
    return overlayJSONData[key];
  }

  void getOverlayKeys() {
    for(var key in overlayJSONData.keys) {
      print(key);
    }
  }

  // Config methods
  String readConfig(String key) {
    return configJSON[key];
  }

  void writeConfig(String key, String data) {
    // var fileWrite = configJSON.openWrite();

    File('config.json').writeAsStringSync('''{\n "$key": "$data"}''');

    // fileWrite.write('{"$key": "$data"}');
  }
}
