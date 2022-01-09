import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {}

/*Widget testWidget({required double width1, required double width2}) {
  return MaterialApp(
    home: AutoSizeGroupBuilder(
      builder: (_, group) => Column(
        children: <Widget>[
          SizedBox(
            width: width1,
            height: 100,
            child: AutoSizeText(
              'XXXXXX',
              style: TextStyle(fontSize: 60),
              minFontSize: 1,
              maxLines: 1,
              group: group,
            ),
          ),
          SizedBox(
            width: width2,
            height: 100.0,
            child: AutoSizeText(
              'XXXXXX',
              style: TextStyle(fontSize: 60),
              minFontSize: 1,
              maxLines: 1,
              group: group,
            ),
          ),
        ],
      ),
    ),
  );
}

void _expectFontSizes(WidgetTester tester, double fontSize) {
  final texts = tester.widgetList(find.byType(Text));
  for (final text in texts) {
    expect(effectiveFontSize(text as Text), fontSize);
  }
}

void main() {
  testWidgets('Group sync', (tester) async {
    await tester.pumpWidget(testWidget(width1: 300, width2: 300));

    _expectFontSizes(tester, 50);

    await tester.pumpWidget(testWidget(width1: 200, width2: 300));

    _expectFontSizes(tester, 33);

    await tester.pumpWidget(testWidget(width1: 200, width2: 150));

    _expectFontSizes(tester, 25);

    await tester.pumpWidget(testWidget(width1: 200, width2: 100));

    _expectFontSizes(tester, 16);

    await tester.pumpWidget(testWidget(width1: 60, width2: 60));

    _expectFontSizes(tester, 10);

    await tester.pumpWidget(testWidget(width1: 200, width2: 60));

    _expectFontSizes(tester, 10);

    await tester.pumpWidget(testWidget(width1: 200, width2: 250));

    _expectFontSizes(tester, 33);

    await tester.pumpWidget(testWidget(width1: 250, width2: 250));

    _expectFontSizes(tester, 41);

    await tester.pumpWidget(testWidget(width1: 300, width2: 300));
    // Upsizing both requires an extra frame to settle on the new size.
    await tester.pump();

    _expectFontSizes(tester, 50);
  });
}

*/