import 'package:flutter/widgets.dart';

TextSpan spanFromString(String text) {
  var index = 0;
  final styles = [
    TextStyle(fontSize: 30),
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    TextStyle(fontSize: 40, fontStyle: FontStyle.italic),
  ];
  final spans = text.split(' ').map((word) {
    if (index == 3) index = 0;
    return TextSpan(
      style: styles[index++],
      text: '$word ',
    );
  }).toList();

  return TextSpan(text: '', children: spans);
}
