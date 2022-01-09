import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Overflow replacement visible on overflow', (tester) async {
    final text = await pumpAndGet<RichText>(
      tester: tester,
      widget: const SizedBox(
        width: 100,
        height: 20,
        child: AutoSizeText(
          'XXXXXX',
          overflowReplacement: Text('OVERFLOW!'),
          minFontSize: 20,
        ),
      ),
    );
    expect(text.text.toPlainText(), 'OVERFLOW!');
  });

  testWidgets('Overflow replacement not visible without overflow',
      (tester) async {
    final text = await pumpAndGet<RichText>(
      tester: tester,
      widget: const SizedBox(
        width: 100,
        height: 20,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 20),
          overflowReplacement: Text('OVERFLOW!'),
        ),
      ),
    );
    expect(text.text.toPlainText(), 'XXXXX');
  });
}
