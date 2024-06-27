import 'package:falcons_esports_overlays_controller/handlers/notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';
import 'json_handler.dart';

JSONHandler jsonHandler = JSONHandler();

class HTTPHandler {
  late var server;

  Future<void> startServer(BuildContext context, path) async {
    try {
      // Start the server with the updated path
      server = await shelf_io.serve(
          createStaticHandler(path, defaultDocument: 'index.html'),
          'localhost',
          8080);
      NotificationHandler.notification(context, "Server started");
    } catch (e) {
      NotificationHandler.notification(
          context, "Server failed to start or is already running");
    }
  }

  void stopServer(BuildContext context) {
    try {
      server.close();
      server = null;
      NotificationHandler.notification(context, "Server stopped successfully");
    } catch (e) {
      NotificationHandler.notification(
          context, "Failed to stop Server, did you start it?");
    }
  }
}
