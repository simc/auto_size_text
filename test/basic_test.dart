import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Only Data', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText("Some Text"),
    );
  });

  testWidgets('Only Data (rich)', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText.rich(TextSpan(text: "Some Text")),
    );
  });

  testWidgets('Uses style fontSize', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 34,
      widget: AutoSizeText(
        "Some Text",
        style: TextStyle(fontSize: 34),
      ),
    );
  });

  testWidgets('Uses style fontSize (rich)', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 35,
      widget: AutoSizeText.rich(
        TextSpan(text: "Some Text"),
        style: TextStyle(fontSize: 35),
      ),
    );
  });

  testWidgets("Respects inherit style", (tester) async {
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
          "AutoSizeText Test",
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
}
