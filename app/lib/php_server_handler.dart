import 'dart:io';

class PHPServerHandler {
  int pid = 0;

  void startServer() {
    Process.run('php', ['-S', '127.0.0.1:8080']);
  }

  void stopServer() {
    if(Platform.isLinux) {
      Process.run('pkill',['php']);
    } else if(Platform.isWindows) {
      Process.run('taskkill', ['/IM', 'php']);
    }
  }
}
