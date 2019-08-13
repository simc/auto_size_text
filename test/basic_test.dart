import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Only Text', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText('Some Text'),
    );
  });

  testWidgets('Crash when text null', (tester) async {
    expect(() => AutoSizeText(null), throwsAssertionError);
  });

  testWidgets('Only text (rich)', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText.rich(TextSpan(text: 'Some Text')),
    );
  });

  testWidgets('Crash when text null (rich)', (tester) async {
    expect(() => AutoSizeText.rich(null), throwsAssertionError);
  });

  testWidgets('Uses style fontSize', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 34,
      widget: AutoSizeText(
        'Some Text',
        style: TextStyle(fontSize: 34),
      ),
    );
  });

  testWidgets('Uses style fontSize (rich)', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 35,
      widget: AutoSizeText.rich(
        TextSpan(text: 'Some Text'),
        style: TextStyle(fontSize: 35),
      ),
    );
  });

  testWidgets('Respects inherit style', (tester) async {
    var defaultStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.yellow,
    );
    var text = await pumpAndGetText(
      tester: tester,
      widget: DefaultTextStyle(
        style: defaultStyle,
        textAlign: TextAlign.right,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        maxLines: 17,
        child: AutoSizeText(
          'AutoSizeText Test',
        ),
      ),
    );
    expect(text.style, defaultStyle);

    var richText = getRichText(tester);
    expect(richText.textAlign, TextAlign.right);
    expect(richText.softWrap, false);
    expect(richText.overflow, TextOverflow.ellipsis);
    expect(richText.maxLines, 17);
  });

  testWidgets('Applies scale even if initial fontSize fits (#25)',
      (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 60,
      widget: AutoSizeText(
        'Some Text',
        style: TextStyle(fontSize: 15),
        textScaleFactor: 4,
      ),
    );
  });

  testWidgets('Uses textKey', (tester) async {
    var textKey = GlobalKey();
    var text = await pumpAndGetText(
      tester: tester,
      widget: AutoSizeText(
        'A text with key',
        textKey: textKey,
      ),
    );
    expect(text.key, textKey);
  });
}
