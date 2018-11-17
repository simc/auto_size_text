import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double effectiveFontSize(Text text) {
  return text.textScaleFactor * text.style.fontSize;
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
}
