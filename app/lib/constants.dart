import 'dart:io';

import 'package:falcons_esports_overlays_controller/handlers/http_handler.dart';
import 'package:falcons_esports_overlays_controller/handlers/json_handler.dart';
import 'package:hexcolor/hexcolor.dart';

// This file stores a bunch of variables needed across the project
class Constants {
  static JSONHandler jsonHandler = JSONHandler();

  static String slashType = Platform.isWindows ? r'\\' + r'\\' : "/";

  static HTTPHandler httpHandler = HTTPHandler();

  static String codePath = jsonHandler.readConfig("path");

  static String imagePath = "$codePath${slashType}Esports-Logo.png";

  static HexColor appTheme = HexColor(jsonHandler.readConfig("appTheme"));
}
