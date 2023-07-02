import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

Widget testWidget(AutoSizeText text) {
  return MaterialApp(
    useInheritedMediaQuery: true,
    home: text,
  );
}

void main() {
  testWidgets('Only Text', (tester) async {
    await pump(
      tester: tester,
      widget: testWidget(AutoSizeText.selectable('Some Text')),
    );
  });

  testWidgets('Only text (rich)', (tester) async {
    await pump(
      tester: tester,
      widget: testWidget(AutoSizeText.richSelectable(TextSpan(text: 'Some Text'))),
    );
  });

  testWidgets('Uses style fontSize', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 34,
      selectable: true,
      widget: testWidget(AutoSizeText.selectable(
        'Some Text',
        style: TextStyle(fontSize: 34),
      )),
    );
  });

  testWidgets('Uses style fontSize (rich)', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 35,
      selectable: true,
      widget: testWidget(AutoSizeText.richSelectable(
        TextSpan(text: 'Some Text'),
        style: TextStyle(fontSize: 35),
      )),
    );
  });

  testWidgets('Applies scale even if initial fontSize fits (#25)', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 60,
      selectable: true,
      widget: testWidget(AutoSizeText.selectable(
        'Some Text',
        style: TextStyle(fontSize: 15),
        textScaleFactor: 4,
      )),
    );
  });

  testWidgets('Uses textKey', (tester) async {
    final textKey = GlobalKey();
    final text = await pumpAndGetSelectableText(
      tester: tester,
      widget: testWidget(AutoSizeText.selectable(
        'A text with key',
        textKey: textKey,
      )),
    );
    expect(text.key, textKey);
  });
}
