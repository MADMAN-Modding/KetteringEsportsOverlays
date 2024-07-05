import 'dart:ui';

import 'package:falcons_esports_overlays_controller/constants.dart';
import 'package:falcons_esports_overlays_controller/pages/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pages
import 'pages/controls.dart';
import 'pages/git.dart';
import 'pages/home.dart';
import 'pages/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        // This may shock you, but it sets the title of the app
        title: 'Falcons Esports Overlay Controller',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Constants.appTheme),
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.white,
              selectionColor: Color.fromARGB(125, 255, 255, 255)),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  // Page selection switch statement
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const GitPage();
        break;
      case 2:
        page = const ControlsPage();
        break;
      case 3:
        page = const HTTPPage();
        break;
      case 4:
        page = const ConfigPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Makes the side panel stuff
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: <Widget>[
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              selectedIconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.white,
              indicatorColor: Constants.appTheme,
              // Tells the app when to minimize the side bar
              extended: false,
              destinations: const [
                // Makes icons for everything that change color based on if they are selected
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.download),
                  label: Text('Overlay Files'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.edit),
                  label: Text('Overlay Data'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.cell_tower),
                  label: Text("Web Server"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text("Config"),
                )
              ],
            ),
            Expanded(
              child: Container(
                color: Constants.appTheme,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
