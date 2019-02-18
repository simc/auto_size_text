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
