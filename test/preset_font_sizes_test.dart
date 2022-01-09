import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Preset font sizes', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 100,
      widget: const SizedBox(
        width: 500,
        height: 100,
        child: AutoSizeText(
          'XXXXX',
          presetFontSizes: [100, 50, 5],
        ),
      ),
    );

    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 50,
      widget: const SizedBox(
        width: 300,
        height: 100,
        child: AutoSizeText(
          'XXXXX',
          presetFontSizes: [100, 50, 5],
        ),
      ),
    );

    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 5,
      widget: const SizedBox(
        width: 20,
        height: 100,
        child: AutoSizeText(
          'XXXXX',
          presetFontSizes: [100, 50, 5],
        ),
      ),
    );
  });
}
