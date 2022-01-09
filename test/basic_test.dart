import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Only Text', (tester) async {
    await pump(
      tester: tester,
      widget: const AutoSizeText('Some Text'),
    );
  });

  testWidgets('Only text (rich)', (tester) async {
    await pump(
      tester: tester,
      widget: const AutoSizeText.rich(TextSpan(text: 'Some Text')),
    );
  });

  testWidgets('Uses style fontSize', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 34,
      widget: const AutoSizeText(
        'Some Text',
        style: TextStyle(fontSize: 34),
      ),
    );
  });

  testWidgets('Uses style fontSize (rich)', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 35,
      widget: const AutoSizeText.rich(
        TextSpan(text: 'Some Text'),
        style: TextStyle(fontSize: 35),
      ),
    );
  });

  testWidgets('Respects inherit style', (tester) async {
    const defaultStyle = TextStyle(
      fontSize: 20,
      color: Colors.yellow,
    );
    final text = await pumpAndGet<RichText>(
      tester: tester,
      widget: const DefaultTextStyle(
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
    expect(text.textAlign, TextAlign.right);
    expect(text.softWrap, false);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.maxLines, 17);
  });

  testWidgets('Applies scale even if initial fontSize fits (#25)',
      (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 60,
      widget: const AutoSizeText(
        'Some Text',
        style: TextStyle(fontSize: 15),
        textScaleFactor: 4,
      ),
    );
  });

  testWidgets('Uses textKey', (tester) async {
    final textKey = GlobalKey();
    final text = await pumpAndGet<Text>(
      tester: tester,
      widget: AutoSizeText(
        'A text with key',
        textKey: textKey,
      ),
    );
    expect(text.key, textKey);
  });
}
