import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('The text is not wrapped by a container', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX',
        style: TextStyle(fontSize: 20),
      ),
    );
    var height = tester.getSize(find.byType(AutoSizeText)).height;
    expect(height, 20);
  });

  testWidgets('The text is wrapped by a container with extra padding',
      (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX',
        style: TextStyle(fontSize: 20),
        wrapTextWidget: (_, text) => Container(
          padding: EdgeInsets.all(5),
          child: text,
        ),
      ),
    );
    var height = tester.getSize(find.byType(AutoSizeText)).height;
    expect(height, 30);
  });
}
