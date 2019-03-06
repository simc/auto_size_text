import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/src/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double effectiveFontSize(Text text) {
  return text.textScaleFactor ?? 1 * text.style.fontSize;
}

bool testIfTextFits(Text text, [double maxWidth, double maxHeight]) {
  var span = text.textSpan ?? TextSpan(text: text.data, style: text.style);
  return checkTextFits(span, text.locale, text.textScaleFactor, text.maxLines,
      maxWidth ?? double.infinity, maxHeight ?? double.infinity);
}

void main() {
  testWidgets("Test use style fontSize", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AutoSizeText(
          "AutoSizeText Test",
          style: TextStyle(fontSize: 25.0),
        ),
      ),
    );

    Text text = tester.widget(find.byType(Text));
    expect(text.style.fontSize, 25.0);
  });

  testWidgets("Test inherit style", (WidgetTester tester) async {
    var defaultStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.yellow,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTextStyle(
          style: defaultStyle,
          textAlign: TextAlign.right,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 17,
          child: AutoSizeText(
            "AutoSizeText Test",
          ),
        ),
      ),
    );

    Text text = tester.widget(find.byType(Text));
    expect(text.style, defaultStyle);

    RichText richText = tester.widget(find.byType(RichText));
    expect(richText.textAlign, TextAlign.right);
    expect(richText.softWrap, false);
    expect(richText.overflow, TextOverflow.ellipsis);
    expect(richText.maxLines, 17);
  });

  testWidgets("Test minFontSize", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 10.0,
            height: 10.0,
            child: AutoSizeText(
              "AutoSizeText Test",
              style: TextStyle(fontSize: 25.0),
              minFontSize: 15.0,
            ),
          ),
        ),
      ),
    );

    Text text = tester.widget(find.byType(Text));
    expect(effectiveFontSize(text) >= 15, true);
  });

  testWidgets("Test maxFontSize", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTextStyle(
          style: TextStyle(fontSize: 30.0),
          child: AutoSizeText(
            "AutoSizeText Test",
            maxFontSize: 20.0,
          ),
        ),
      ),
    );

    Text text = tester.widget(find.byType(Text));
    expect(effectiveFontSize(text) <= 20, true);
  });

  testWidgets("Test fits width", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 100.0,
            height: 100.0,
            child: AutoSizeText(
              "This is a very long text, which needs to be resized to fit the sized box.",
              style: TextStyle(fontSize: 30.0),
              maxLines: 1,
              minFontSize: 1,
            ),
          ),
        ),
      ),
    );

    Text text = tester.widget(find.byType(Text));
    expect(testIfTextFits(text, 100), true);
  });

  testWidgets("Test RichText fits width", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 120.0,
            height: 100.0,
            child: AutoSizeText.rich(
              TextSpan(
                text:
                    "This is a very long text, which needs to be resized to fit the sized box.",
                style: TextStyle(fontSize: 30.0),
              ),
              maxLines: 1,
              minFontSize: 1,
            ),
          ),
        ),
      ),
    );

    Text text = tester.widget(find.byType(Text));
    expect(testIfTextFits(text, 120), true);
  });

  testWidgets("Test fits height", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 100.0,
            height: 100.0,
            child: AutoSizeText(
              "This is a very long text, which needs to be resized to fit the sized box.",
              style: TextStyle(fontSize: 30.0),
              minFontSize: 1,
            ),
          ),
        ),
      ),
    );

    Text text = tester.widget(find.byType(Text));
    expect(testIfTextFits(text, 100, 100), true);
  });

  testWidgets("Test presetFontSizes", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTextStyle(
          style: TextStyle(fontSize: 30.0),
          child: AutoSizeText(
            "This text is only allowed to have specific font sizes.",
            presetFontSizes: [15, 20, 30],
          ),
        ),
      ),
    );

    Text text = tester.widget(find.byType(Text));
    expect(effectiveFontSize(text) == 15, true);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 10.0,
            height: 10.0,
            child: AutoSizeText(
              "This text is only allowed to have specific font sizes.",
              presetFontSizes: [100, 50, 10],
            ),
          ),
        ),
      ),
    );

    text = tester.widget(find.byType(Text));
    expect(effectiveFontSize(text) == 10, true);
  });

  testWidgets("Test stepGranularity", (WidgetTester tester) async {
    for (int i = 0; i < 300; i++) {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: i.toDouble(),
              height: 50.0,
              child: AutoSizeText(
                "This text should have stepGranularity 10.",
                style: TextStyle(fontSize: 100),
                maxLines: 1,
                stepGranularity: 10,
              ),
            ),
          ),
        ),
      );

      Text text = tester.widget(find.byType(Text));
      expect(effectiveFontSize(text) % 10 < 0.00001, true);
    }
  });
}
