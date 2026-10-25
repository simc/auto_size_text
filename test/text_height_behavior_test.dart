import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

const _behavior = TextHeightBehavior(
  applyHeightToFirstAscent: false,
  applyHeightToLastDescent: false,
);

// With height 2, two lines of the test font are 4 * fontSize tall. Without
// the height above the first and below the last line they are 3 * fontSize.
const _style = TextStyle(fontSize: 100, height: 2);

Widget _box(Widget child) => SizedBox(width: 400, height: 60, child: child);

void main() {
  testWidgets('Without textHeightBehavior', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 15,
      widget: _box(AutoSizeText('A\nB', style: _style, maxLines: 2)),
    );
  });

  testWidgets('Uses textHeightBehavior to calculate the font size',
      (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: _box(AutoSizeText(
        'A\nB',
        style: _style,
        maxLines: 2,
        textHeightBehavior: _behavior,
      )),
    );
    expect(effectiveFontSize(text), 20);
    expect(text.textHeightBehavior, _behavior);
    expect(getRichText(tester).textHeightBehavior, _behavior);
    expect(tester.getSize(find.byType(RichText)).height, lessThanOrEqualTo(60));
  });

  testWidgets('Uses textHeightBehavior to calculate the font size (rich)',
      (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: _box(AutoSizeText.rich(
        TextSpan(text: 'A\nB'),
        style: _style,
        maxLines: 2,
        textHeightBehavior: _behavior,
      )),
    );
    expect(effectiveFontSize(text), 20);
    expect(text.textHeightBehavior, _behavior);
    expect(getRichText(tester).textHeightBehavior, _behavior);
  });

  testWidgets('Falls back to DefaultTextStyle.textHeightBehavior',
      (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: DefaultTextStyle(
        style: TextStyle(),
        textHeightBehavior: _behavior,
        child: _box(AutoSizeText('A\nB', style: _style, maxLines: 2)),
      ),
    );
    expect(effectiveFontSize(text), 20);
    expect(getRichText(tester).textHeightBehavior, _behavior);
  });

  testWidgets('Falls back to DefaultTextHeightBehavior', (tester) async {
    final text = await pumpAndGetText(
      tester: tester,
      widget: DefaultTextHeightBehavior(
        textHeightBehavior: _behavior,
        child: _box(AutoSizeText('A\nB', style: _style, maxLines: 2)),
      ),
    );
    expect(effectiveFontSize(text), 20);
    expect(getRichText(tester).textHeightBehavior, _behavior);
  });

  testWidgets('textHeightBehavior overrides DefaultTextStyle', (tester) async {
    const behavior = TextHeightBehavior();
    final text = await pumpAndGetText(
      tester: tester,
      widget: DefaultTextStyle(
        style: TextStyle(),
        textHeightBehavior: _behavior,
        child: _box(AutoSizeText(
          'A\nB',
          style: _style,
          maxLines: 2,
          textHeightBehavior: behavior,
        )),
      ),
    );
    expect(effectiveFontSize(text), 15);
    expect(getRichText(tester).textHeightBehavior, behavior);
  });
}
