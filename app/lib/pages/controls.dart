import 'package:falcons_esports_overlays_controller/common_widgets/color_selector.dart';
import 'package:falcons_esports_overlays_controller/common_widgets/default_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../handlers/json_handler.dart';
import '../common_widgets/text_editor.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  // Lots of textEditingControllers
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

// Default color values
  Color teamColorLeftDefault = const Color.fromRGBO(190, 15, 50, 1);
  Color teamColorRightDefault = Colors.white;

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

    // Tries to get the color values
    try {
      teamColorLeftDefault = HexColor(jsonHandler.readOverlay("teamColorLeft"));
      teamColorRightDefault =
          HexColor(jsonHandler.readOverlay("teamColorRight"));
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Makes a box that holds everything
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          // Overlay Switchers
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildOverlayButton('ssbu', 'images/SSBU.png'),
              buildOverlayButton('kart', 'images/Kart.png'),
              buildOverlayButton('overwatch', 'images/Overwatch.png'),
              buildOverlayButton('rocketLeague', 'images/RL.png'),
              buildOverlayButton('splat', 'images/SPLAT.png'),
              buildOverlayButton('val', 'images/VAL.png'),
              buildOverlayButton('hearth', 'images/Hearth.png'),
              buildOverlayButton('lol', 'images/LOL.png'),
              buildOverlayButton('chess', 'images/Chess.png'),
              buildOverlayButton('nba2k', 'images/NBA2K.png'),
              buildOverlayButton('madden', 'images/Madden.png')
            ],
          ),
          // Spacer
          const SizedBox(height: 20),
          // Row that holds everything
          Row(
            // Makes all the columns
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTeamColumn(
                teamSide: "Left",
                controllers: [scoreLeft, playerNamesLeft, teamNameLeft],
                widths: [40, 260, 260],
                heights: [40, 40, 40],
                labels: ["Score", "Player Names", "Team Name"],
                colorController: teamColorLeft,
                sideColor: teamColorLeftDefault,
              ),
              buildMiddleColumn(),
              buildTeamColumn(
                teamSide: "Right",
                controllers: [scoreRight, playerNamesRight, teamNameRight],
                widths: [40, 260, 260],
                heights: [40, 40, 40],
                labels: ["Score", "Player Names", "Team Name"],
                colorController: teamColorRight,
                sideColor: teamColorRightDefault,
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
        width: 70,
        height: 70,
      ),
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
      required List<double> widths,
      required List<double> heights,
      required List<String> labels,
      required TextEditingController colorController,
      required Color sideColor}) {
    List<Widget> winButtons = [];
    // For every about of wins your team can have, this will make a button for that
    for (int i = 0; i < 4; i++) {
      winButtons
          .add(scoreButton(text: "$i", jsonKey: "wins$teamSide", value: i));
    }
    // All the textEditors to be used
    List<Widget> textEditors = [];

// Foreach controller adds a text editor
    for (int i = 0; i < controllers.length; i++) {
      textEditors.add(
        TextEditor.textEditor(
            width: widths[i],
            height: heights[i],
            controller: controllers[i],
            label: labels[i],
            boxHeight: 5),
      );
    }

    // Returns a column with all the needed info for a team
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
        Text(
          "$teamSide Wins",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 10),
        Row(children: winButtons),
        Column(children: textEditors),
        const SizedBox(height: 15),
        Column(
          children: [
            // Makes the color selectors
            DefaultText.text("Team Color"),
            ColorSelector.colorPicker(
                color: sideColor,
                colorController: colorController,
                config: false,
                key: "teamColor$teamSide"),
            TextEditor.textEditor(
                width: 80,
                height: 50,
                controller: colorController,
                label: "",
                boxHeight: 0),
          ],
        )
      ],
    );
  }

  Widget buildMiddleColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(
          children: [
            Text("Update Overlay",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            // Update all the values
            ElevatedButton(
                onPressed: () {
                  jsonHandler.writeOverlay("scoreLeft", scoreLeft.text);
                  jsonHandler.writeOverlay("scoreRight", scoreRight.text);
                  jsonHandler.writeOverlay("teamNameLeft", teamNameLeft.text);
                  jsonHandler.writeOverlay("teamNameRight", teamNameRight.text);
                  jsonHandler.writeOverlay("teamColorLeft", teamColorLeft.text);
                  jsonHandler.writeOverlay(
                      "teamColorRight", teamColorRight.text);
                  jsonHandler.writeOverlay("week", week.text);
                  jsonHandler.writeOverlay(
                      "playerNamesLeft", playerNamesLeft.text);
                  jsonHandler.writeOverlay(
                      "playerNamesRight", playerNamesRight.text);
                },
                child: const Icon(Icons.system_update_alt)),
          ],
        ),
        const SizedBox(height: 15),
        const Row(
          children: [
            Text("Swap Values",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15))
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  try {
                    // All temp values will be set to the left value at first
                    String tempWins = jsonHandler.readOverlay("winsLeft");
                    String tempScore = scoreLeft.text;
                    String tempPlayerNames = playerNamesLeft.text;
                    String tempTeamName = teamNameLeft.text;
                    String tempTeamColor = teamColorLeft.text;

                    // Set the left side equal to the right
                    jsonHandler.writeOverlay(
                        "winsLeft", jsonHandler.readOverlay("winsRight"));
                    scoreLeft.text = scoreRight.text;
                    playerNamesLeft.text = playerNamesRight.text;
                    teamNameLeft.text = teamNameRight.text;
                    teamColorLeft.text = teamColorRight.text;

                    // Set the right equal to the temp values
                    jsonHandler.writeOverlay("winsRight", tempWins);
                    scoreRight.text = tempScore;
                    playerNamesRight.text = tempPlayerNames;
                    teamNameRight.text = tempTeamName;
                    teamColorRight.text = tempTeamColor;

                    // Write the new data to the json file
                    List<TextEditingController> controllers = [
                      scoreLeft,
                      playerNamesLeft,
                      teamNameLeft,
                      teamColorLeft,
                      scoreRight,
                      playerNamesRight,
                      teamNameRight,
                      teamColorRight
                    ];

                    List<String> keys = [
                      "scoreLeft",
                      "playerNamesLeft",
                      "teamNameLeft",
                      "teamColorLeft",
                      "scoreRight",
                      "playerNamesRight",
                      "teamNameRight",
                      "teamColorRight"
                    ];

                    for (int i = 0; i < controllers.length; i++) {
                      jsonHandler.writeOverlay(keys[i], controllers[i].text);
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: const Icon(Icons.swap_horiz_sharp))
          ],
        ),
        Row(
          children: [
            TextEditor.textEditor(
                width: 20,
                height: 40,
                controller: week,
                label: "Week",
                boxHeight: 5)
          ],
        ),
      ],
    );
  }
}
