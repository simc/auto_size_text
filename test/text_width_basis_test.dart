import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

Widget _constrained(Widget child) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 100),
    child: child,
  );
}

double _renderedWidth(WidgetTester tester) =>
    tester.getSize(find.byType(RichText)).width;

void main() {
  testWidgets('Uses parent width basis by default', (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: _constrained(
        AutoSizeText(
          'XXXX XX',
          style: TextStyle(fontSize: 20),
          maxLines: 2,
        ),
      ),
    );
    expect(text.textWidthBasis, null);
    expect(effectiveFontSize(text), 20);
    expect(_renderedWidth(tester), 100);
  });

  testWidgets('Respects textWidthBasis', (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: _constrained(
        AutoSizeText(
          'XXXX XX',
          style: TextStyle(fontSize: 20),
          maxLines: 2,
          textWidthBasis: TextWidthBasis.longestLine,
        ),
      ),
    );
    expect(text.textWidthBasis, TextWidthBasis.longestLine);
    expect(effectiveFontSize(text), 20);
    expect(_renderedWidth(tester), 80);
  });

  testWidgets('Respects textWidthBasis with rich text', (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: _constrained(
        AutoSizeText.rich(
          TextSpan(text: 'XXXX', children: [TextSpan(text: ' XX')]),
          style: TextStyle(fontSize: 20),
          maxLines: 2,
          textWidthBasis: TextWidthBasis.longestLine,
        ),
      ),
    );
    expect(text.textWidthBasis, TextWidthBasis.longestLine);
    expect(effectiveFontSize(text), 20);
    expect(_renderedWidth(tester), 80);
  });

  testWidgets('Falls back to DefaultTextStyle.textWidthBasis', (tester) async {
    await pump(
      tester: tester,
      widget: DefaultTextStyle(
        style: TextStyle(fontSize: 20),
        textWidthBasis: TextWidthBasis.longestLine,
        child: _constrained(
          AutoSizeText('XXXX XX', maxLines: 2),
        ),
      ),
    );
    expect(_renderedWidth(tester), 80);

    await pump(
      tester: tester,
      widget: DefaultTextStyle(
        style: TextStyle(fontSize: 20),
        textWidthBasis: TextWidthBasis.longestLine,
        child: _constrained(
          AutoSizeText(
            'XXXX XX',
            maxLines: 2,
            textWidthBasis: TextWidthBasis.parent,
          ),
        ),
      ),
    );
    expect(_renderedWidth(tester), 100);
  });
}
