import 'package:falcons_esports_overlays_controller/handlers/php_server_handler.dart';
import 'package:flutter/material.dart';

class PHPPage extends StatefulWidget {
  const PHPPage({super.key});

  @override
  State<StatefulWidget> createState() => _PHPPage();
}

class _PHPPage extends State<PHPPage> {
  String chosenPath = "";
  PHPServerHandler php = PHPServerHandler();

  var directory = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      php.startServer();
                    },
                    child: const Text("Start PHP Server")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      php.stopServer();
                    },
                    child: Text("Stop PHP Server")),
              )
            ],
          )
        ],
      ),
    );
  }
}
