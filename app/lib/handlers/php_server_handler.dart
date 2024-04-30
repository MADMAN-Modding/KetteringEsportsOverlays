import 'dart:io';
import 'package:falcons_esports_overlays_controller/constants.dart';

import 'json_handler.dart';

class PHPServerHandler {
  int pid = 0;

  JSONHandler jsonHandler = JSONHandler();

  void startServer(String pathModifier) {
    Process.run(jsonHandler.readConfig('phpPath'), ['-S', '127.0.0.1:8080'],
        workingDirectory:
            "${jsonHandler.readConfig('path')}${Constants.slashType}$pathModifier");
  }

  void stopServer() {
    if (Platform.isLinux) {
      Process.run('pkill', ['php']);
    } else if (Platform.isWindows) {
      Process.run('taskkill', ['/IM', 'php', '/F']);
    }
  }
}
