import 'package:flutter/material.dart';

class TextEditor {
  Widget textEditor({
    required double width,
    required double height,
    required TextEditingController controller,
    required String? label,
  }) {
    Widget widget = Column(
      children: [
        const SizedBox(height: 5),
        if (label!.isNotEmpty) ...[labelMaker(label)],
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
              ),
            )
          ],
        ),
      ],
    );

    return widget;
  }

  Widget labelMaker(String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        )
      ],
    );
  }
}
