import 'dart:ui';

import 'package:flutter/widgets.dart';

bool checkTextFits(TextSpan text, Locale locale, double scale, int maxLines,
    double maxWidth, double maxHeight) {
  var tp = TextPainter(
    text: text,
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
    textScaleFactor: scale ?? 1,
    maxLines: maxLines,
    locale: locale,
  );

  tp.layout(maxWidth: maxWidth);

  return !(tp.didExceedMaxLines ||
      tp.height > maxHeight ||
      tp.width > maxWidth);
}

bool checkWordsWrapping(
    TextSpan text, Locale locale, double scale, double maxWidth) {
  int wordCount = 0;
  TextSpan oneLineForEachWord(TextSpan span) {
    List<TextSpan> children;
    if (span.children != null) {
      children = List(span.children.length);
      for (var child in span.children) {
        children.add(oneLineForEachWord(child));
      }
    }

    var words = span.text.split(' ');
    wordCount += words.length;
    var text = words.join('\n');
    return TextSpan(text: text, style: span.style, children: children);
  }

  var splitSpan = oneLineForEachWord(text);

  var tp = TextPainter(
    text: splitSpan,
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
    textScaleFactor: scale ?? 1,
    maxLines: wordCount,
    locale: locale,
  );

  tp.layout(maxWidth: maxWidth);

  return tp.didExceedMaxLines;
}
