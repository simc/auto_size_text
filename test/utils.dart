import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

double effectiveFontSize(Text text) =>
    (text.textScaleFactor ?? 1) * text.style!.fontSize!;

bool doesTextFit(
  Text text, [
  double maxWidth = double.infinity,
  double maxHeight = double.infinity,
  bool wrapWords = true,
]) {
  final span = text.textSpan ?? TextSpan(text: text.data, style: text.style);
  var maxLines = text.maxLines;
  if (!wrapWords) {
    final wordCount = span.toPlainText().split(RegExp('\\s+')).length;
    maxLines = maxLines!.clamp(1, wordCount);
  }

  final textPainter = TextPainter(
    text: span,
    textAlign: text.textAlign ?? TextAlign.start,
    textDirection: text.textDirection,
    textScaleFactor: text.textScaleFactor ?? 1,
    maxLines: text.maxLines,
    locale: text.locale,
    strutStyle: text.strutStyle,
  );

  textPainter.layout(maxWidth: maxWidth);

  return !(textPainter.didExceedMaxLines ||
      textPainter.height > maxHeight ||
      textPainter.width > maxWidth);
}

bool prepared = false;

Future prepareTests(WidgetTester tester) async {
  if (prepared) {
    return;
  }

  tester.binding.addTime(Duration(seconds: 10));
  prepared = true;
  final fontData = File('test/assets/Roboto-Regular.ttf')
      .readAsBytes()
      .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));

  final fontLoader = FontLoader('Roboto')..addFont(fontData);
  await fontLoader.load();
}

Future pump({
  required WidgetTester tester,
  required Widget widget,
}) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: widget,
      ),
    ),
  );
}

Future<Text> pumpAndGetText({
  required WidgetTester tester,
  required Widget widget,
}) async {
  await pump(tester: tester, widget: widget);
  return tester.widget<Text>(find.byType(Text));
}

Future pumpAndExpectFontSize({
  required WidgetTester tester,
  required double expectedFontSize,
  required Widget widget,
}) async {
  final text = await pumpAndGetText(tester: tester, widget: widget);
  expect(effectiveFontSize(text), expectedFontSize);
}

RichText getRichText(WidgetTester tester) =>
    tester.widget(find.byType(RichText));

class OverflowNotifier extends StatelessWidget {
  final VoidCallback overflowCallback;

  OverflowNotifier(this.overflowCallback);

  @override
  Widget build(BuildContext context) {
    overflowCallback();
    return Container();
  }
}
