import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets('Text fits width', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 20,
      widget: SizedBox(
        width: 100,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 60),
          maxLines: 1,
        ),
      ),
    );

    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 17,
      widget: SizedBox(
        width: 85,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 200),
          maxLines: 1,
        ),
      ),
    );

    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 1,
      widget: SizedBox(
        width: 6,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 20),
          maxLines: 1,
          minFontSize: 1,
        ),
      ),
    );

    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 20,
      widget: SizedBox(
        width: 100,
        child: AutoSizeText(
          'XXXXX XXXXX XXXXX',
          style: TextStyle(fontSize: 30),
          maxLines: 3,
        ),
      ),
    );
  });

  testWidgets('Text fits height', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 30,
      widget: SizedBox(
        height: 30,
        child: AutoSizeText(
          'XXXXX',
          style: TextStyle(fontSize: 60),
          maxLines: 1,
        ),
      ),
    );

    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 30,
      widget: SizedBox(
        width: 120,
        height: 60,
        child: AutoSizeText(
          'XXXXXX',
          style: TextStyle(fontSize: 200),
          maxLines: 2,
        ),
      ),
    );

    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 47,
      widget: SizedBox(
        width: 120,
        height: 141,
        child: AutoSizeText(
          'XX XX XX',
          style: TextStyle(fontSize: 200),
          maxLines: 3,
        ),
      ),
    );
  });

  testWidgets('Handle style.fontSize fraction', (tester) async {
    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 33.5,
      widget: SizedBox(
        width: 201,
        height: 40,
        child: AutoSizeText(
          'XXXXXX',
          style: TextStyle(fontSize: 33.5),
          maxLines: 1,
          stepGranularity: 1,
        ),
      ),
    );

    await pumpAndExpectFontSize(
      tester: tester,
      expectedFontSize: 33,
      widget: SizedBox(
        width: 200.9,
        height: 40,
        child: AutoSizeText(
          'XXXXXX',
          style: TextStyle(fontSize: 33.5),
          maxLines: 1,
          stepGranularity: 1,
        ),
      ),
    );
  });
}
