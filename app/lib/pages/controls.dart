import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hexcolor/hexcolor.dart';
import '../handlers/json_handler.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  final TextEditingController scoreLeft = TextEditingController();
  final TextEditingController scoreRight = TextEditingController();
  final TextEditingController teamNameLeft = TextEditingController();
  final TextEditingController teamNameRight = TextEditingController();
  final TextEditingController week = TextEditingController();
  final TextEditingController teamColorRight = TextEditingController();
  final TextEditingController teamColorLeft = TextEditingController();
  final TextEditingController playerNamesRight = TextEditingController();
  final TextEditingController playerNamesLeft = TextEditingController();
  final JSONHandler jsonHandler = JSONHandler();

  Color leftTeamColor = const Color.fromRGBO(190, 15, 50, 1);
  Color rightTeamColor = Colors.white;

  @override
  void initState() {
    super.initState();

    // Initialize controller values
    scoreLeft.text = jsonHandler.readOverlay('scoreLeft');
    scoreRight.text = jsonHandler.readOverlay('scoreRight');
    teamNameLeft.text = jsonHandler.readOverlay('teamNameLeft');
    teamNameRight.text = jsonHandler.readOverlay('teamNameRight');
    week.text = jsonHandler.readOverlay('week');
    teamColorLeft.text = jsonHandler.readOverlay('teamColorLeft');
    teamColorRight.text = jsonHandler.readOverlay('teamColorRight');
    playerNamesLeft.text = jsonHandler.readOverlay('playerNamesLeft');
    playerNamesRight.text = jsonHandler.readOverlay('playerNamesRight');

    try {
      leftTeamColor = HexColor(jsonHandler.readOverlay("teamColorLeft"));
      rightTeamColor = HexColor(jsonHandler.readOverlay("teamColorRight"));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          // Overlay Switchers
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildOverlayButton('ssbu', 'images/SSBU.png'),
              buildOverlayButton('kart', 'images/Kart.png'),
              buildOverlayButton('rocketLeague', 'images/RL.png'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTeamColumn(
                teamSide: "Left",
                controllers: [scoreLeft, playerNamesLeft],
                jsonKeys: ["scoreLeft", "playerNamesLeft"],
                widths: [40, 260],
                heights: [40, 40],
                labels: ["Score", "Player Names"],
                colorController: teamColorLeft,
                sideColor: leftTeamColor,
              ),
              buildMiddleColumn(),
              buildTeamColumn(
                teamSide: "Right",
                controllers: [scoreRight, playerNamesRight],
                jsonKeys: ["scoreRight", "playerNamesRight"],
                widths: [40, 260],
                heights: [40, 40],
                labels: ["Score", "Player Names"],
                colorController: teamColorRight,
                sideColor: rightTeamColor,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildOverlayButton(String overlay, String imagePath) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        jsonHandler.writeOverlay("overlay", overlay);
      },
      child: Image.asset(
        imagePath,
        width: 100,
        height: 100,
      ),
    );
  }

  Widget textEditor({
    required String jsonKey,
    required double width,
    required double height,
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            )
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    )),
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                onChanged: (value) => jsonHandler.writeOverlay(jsonKey, value),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget scoreButton(
      {required String text, required String jsonKey, required int value}) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(right: 4),
            child: ElevatedButton(
              onPressed: () {
                jsonHandler.writeOverlay(jsonKey, "$value");
              },
              child: Text(text),
            ))
      ],
    );
  }

  Widget buildTeamColumn(
      {required String teamSide,
      required List<TextEditingController> controllers,
      required List<String> jsonKeys,
      required List<double> widths,
      required List<double> heights,
      required List<String> labels,
      required TextEditingController colorController,
      required Color sideColor}) {
    List<Widget> winButtons = [];

    for (int i = 0; i < 4; i++) {
      winButtons
          .add(scoreButton(text: "$i", jsonKey: "wins$teamSide", value: i));
    }
    List<Widget> textEditors = [];

    for (int i = 0; i < controllers.length; i++) {
      textEditors.add(
        textEditor(
          jsonKey: jsonKeys[i],
          width: widths[i],
          height: heights[i],
          controller: controllers[i],
          label: labels[i],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "$teamSide Team",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(children: winButtons),
        Column(children: textEditors),
        const SizedBox(height: 15),
        Column(
          children: [
            const Text("Team Color",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            ColorPicker(
              pickerColor: sideColor,
              onColorChanged: (Color color) {
                jsonHandler.writeOverlay("teamColor$teamSide",
                    "#$color".replaceAll("Color(0xff", "").replaceAll(")", ""));
                colorController.text =
                    "#$color".replaceAll("Color(0xff", "").replaceAll(")", "");
              },
              enableAlpha: false,
              colorPickerWidth: 100,
              labelTypes: [],
            ),
            SizedBox(
                width: 80,
                height: 100,
                child: textEditor(
                    jsonKey: "teamColor$teamSide",
                    width: 80,
                    height: 50,
                    controller: colorController,
                    label: "")),
          ],
        )
      ],
    );
  }

  Widget buildMiddleColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            textEditor(
                jsonKey: 'week',
                width: 20,
                height: 40,
                controller: week,
                label: "Week")
          ],
        ),
      ],
    );
  }
}
