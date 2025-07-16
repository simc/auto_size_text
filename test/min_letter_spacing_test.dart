import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Does not change letterSpacing if no minLetterSpacing is passed',
      (tester) async {
    await pumpAndExpectLetterSpacing(
      tester: tester,
      expectedLetterSpacing: null,
      widget: SizedBox(
        width: 100,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 60),
          minFontSize: 60,
          maxLines: 1,
        ),
      ),
    );
  });

  testWidgets('Does not change letterSpacing if the text fits with minFontSize',
      (tester) async {
    await pumpAndExpectLetterSpacing(
      tester: tester,
      expectedLetterSpacing: null,
      widget: SizedBox(
        width: 100,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 60),
          minFontSize: 20,
          maxLines: 1,
          minLetterSpacing: -60,
        ),
      ),
    );
  });

  testWidgets('Respects minLetterSpacing', (tester) async {
    await pumpAndExpectLetterSpacing(
      tester: tester,
      expectedLetterSpacing: -20,
      widget: SizedBox(
        width: 100,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 60),
          minFontSize: 60,
          maxLines: 1,
          minLetterSpacing: -20,
        ),
      ),
    );
  });

  testWidgets('letterSpacing is larger than minLetterSpacing if enough space',
      (tester) async {
    await pumpAndExpectLetterSpacing(
      tester: tester,
      expectedLetterSpacing: -40,
      widget: SizedBox(
        width: 100,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 60),
          minFontSize: 60,
          maxLines: 1,
          minLetterSpacing: -60,
        ),
      ),
    );
  });
}
