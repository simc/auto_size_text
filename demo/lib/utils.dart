import 'package:flutter/widgets.dart';

TextSpan spanFromString(String text) {
  var index = 0;
  var styles = [
    TextStyle(fontSize: 30.0),
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    TextStyle(fontSize: 40.0, fontStyle: FontStyle.italic),
  ];
  var spans = text.split(' ').map((word) {
    if (index == 3) index = 0;
    return TextSpan(
      style: styles[index++],
      text: word + ' ',
    );
  }).toList();

  return TextSpan(text: '', children: spans);
}
