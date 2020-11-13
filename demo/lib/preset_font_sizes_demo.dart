import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'animated_input.dart';
import 'text_card.dart';
import 'utils.dart';

class PresetFontSizesDemo extends StatelessWidget {
  final bool richText;

  PresetFontSizesDemo(this.richText);

  @override
  Widget build(BuildContext context) {
    return AnimatedInput(
      text: 'This String has only three allowed sizes: 40, 20 and 14. It will '
          'be automatically resized to fit on 4 lines. With this setting, you '
          'have the most control.',
      builder: (input) {
        return Row(
          children: <Widget>[
            Expanded(
              child: TextCard(
                title: 'Text',
                child: !richText
                    ? Text(
                        input,
                        style: TextStyle(fontSize: 40),
                        maxLines: 4,
                      )
                    : Text.rich(
                        spanFromString(input),
                        style: TextStyle(fontSize: 40),
                        maxLines: 4,
                      ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextCard(
                title: 'AutoSizeText',
                child: !richText
                    ? AutoSizeText(
                        input,
                        presetFontSizes: [40, 20, 14],
                        maxLines: 4,
                      )
                    : AutoSizeText.rich(
                        spanFromString(input),
                        presetFontSizes: [40, 20, 14],
                        maxLines: 4,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
