import '../constants.dart' as constants;
import 'package:flutter/material.dart';

// All this does is return the default text options, wahoo
class DefaultText {
  static Widget text(String input) {
    double multiplier = constants.Constants.multiplier;

    return Text(
      input,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17 * multiplier),
    );
  }
}
