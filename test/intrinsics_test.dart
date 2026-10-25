import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

RenderBox autoSizeTextBox(WidgetTester tester) =>
    tester.renderObject<RenderBox>(find.byType(AutoSizeText));

void main() {
  testWidgets('Works inside IntrinsicHeight and Row (#30)', (tester) async {
    await pump(
      tester: tester,
      widget: SizedBox(
        width: 200,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 20, height: 40),
              Expanded(
                child: AutoSizeText(
                  'XXXXXXXXXXXX',
                  style: TextStyle(fontSize: 30),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    // 12 glyphs in 180px -> 15px font, so the 40px box decides the height.
    expect(tester.getSize(find.byType(Row)).height, 40);
    final text = tester.widget<Text>(find.byType(Text));
    expect(effectiveFontSize(text), 15);
  });

  testWidgets('Works inside IntrinsicWidth', (tester) async {
    await pump(
      tester: tester,
      widget: IntrinsicWidth(
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(IntrinsicWidth)).width, 100);
  });

  testWidgets('Works in a Table with IntrinsicColumnWidth', (tester) async {
    await pump(
      tester: tester,
      widget: Table(
        columnWidths: {0: IntrinsicColumnWidth()},
        defaultColumnWidth: FixedColumnWidth(50),
        children: [
          TableRow(children: [
            AutoSizeText('XXXXX', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
          ]),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(AutoSizeText)).width, 100);
  });

  testWidgets('Works in SliverFillRemaining without scroll body',
      (tester) async {
    await pump(
      tester: tester,
      widget: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AutoSizeText('XXXXX', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('Intrinsic height matches the fitted font size', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX XXXXX',
        style: TextStyle(fontSize: 20),
        minFontSize: 1,
        maxLines: 2,
      ),
    );

    final box = autoSizeTextBox(tester);
    // Two lines of 20px fit into 100px.
    expect(box.getMinIntrinsicHeight(100), 40);
    expect(box.getMaxIntrinsicHeight(100), 40);
    // Only 50px wide: each word needs its own line at 10px.
    expect(box.getMaxIntrinsicHeight(50), 20);
    // Unconstrained width keeps the preferred size on a single line.
    expect(box.getMaxIntrinsicHeight(double.infinity), 20);
  });

  testWidgets('Intrinsic width respects height and minFontSize',
      (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX XX',
        style: TextStyle(fontSize: 20),
        minFontSize: 10,
        maxLines: 1,
      ),
    );

    final box = autoSizeTextBox(tester);
    expect(box.getMaxIntrinsicWidth(double.infinity), 160);
    // A 10px tall box only allows a 10px font.
    expect(box.getMaxIntrinsicWidth(10), 80);
    // A single line cannot wrap, so the whole line at minFontSize.
    expect(box.getMinIntrinsicWidth(double.infinity), 80);
  });

  testWidgets('Min intrinsic width is the longest word when wrapping',
      (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX XX',
        style: TextStyle(fontSize: 20),
        minFontSize: 10,
        maxLines: 2,
      ),
    );

    expect(autoSizeTextBox(tester).getMinIntrinsicWidth(double.infinity), 50);
  });

  testWidgets('Intrinsic width with presetFontSizes', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX',
        style: TextStyle(fontSize: 20),
        presetFontSizes: [30, 15, 8],
        maxLines: 1,
      ),
    );

    final box = autoSizeTextBox(tester);
    expect(box.getMaxIntrinsicWidth(double.infinity), 150);
    expect(box.getMaxIntrinsicWidth(20), 75);
    expect(box.getMinIntrinsicWidth(double.infinity), 40);
  });

  testWidgets('Intrinsic size of rich text', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText.rich(
        TextSpan(text: 'XXXXX'),
        style: TextStyle(fontSize: 20),
        minFontSize: 1,
        maxLines: 1,
      ),
    );

    final box = autoSizeTextBox(tester);
    expect(box.getMaxIntrinsicWidth(double.infinity), 100);
    expect(box.getMaxIntrinsicHeight(50), 10);
  });

  testWidgets('Intrinsic size follows textScaleFactor', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX',
        style: TextStyle(fontSize: 20),
        textScaleFactor: 2,
        maxLines: 1,
      ),
    );

    final box = autoSizeTextBox(tester);
    expect(box.getMaxIntrinsicWidth(double.infinity), 200);
  });

  testWidgets('Dry layout matches the real layout', (tester) async {
    await pump(
      tester: tester,
      widget: SizedBox(
        width: 70,
        child: AutoSizeText(
          'XXXXX XXXXX XXXXX',
          style: TextStyle(fontSize: 30),
          maxLines: 2,
        ),
      ),
    );

    final box = autoSizeTextBox(tester);
    expect(box.getDryLayout(box.constraints), box.size);
  });

  testWidgets('Intrinsic size uses the font size of the group', (tester) async {
    final group = AutoSizeGroup();
    await pump(
      tester: tester,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            child: AutoSizeText(
              'XXXXX',
              style: TextStyle(fontSize: 20),
              group: group,
              minFontSize: 1,
              maxLines: 1,
            ),
          ),
          IntrinsicWidth(
            child: AutoSizeText(
              'XXXXX',
              key: Key('measured'),
              style: TextStyle(fontSize: 20),
              group: group,
              minFontSize: 1,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byKey(Key('measured'))).width, 50);
  });
}
