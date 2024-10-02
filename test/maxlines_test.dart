import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

import 'utils.dart';

void main() {
  LeakTesting.settings = LeakTesting.settings.withIgnored(createdByTestHelpers: true);
  LeakTesting.enable();

  testWidgets('Respects maxlines', (tester) async {
    await pump(
      tester: tester,
      widget: AutoSizeText(
        'XXXXX',
        style: TextStyle(fontSize: 27),
        maxLines: 1,
      ),
    );
    var height = tester.getSize(find.byType(RichText)).height;
    expect(height, 27);

    await pump(
      tester: tester,
      widget: SizedBox(
        width: 75,
        child: AutoSizeText(
          'XXX XXX',
          style: TextStyle(fontSize: 25),
          maxLines: 2,
        ),
      ),
    );
    height = tester.getSize(find.byType(RichText)).height;
    expect(height, 50);
  });

  testWidgets('Unlimited maxLines if parameter null', (tester) async {});
}
