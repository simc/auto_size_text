import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'animated_input.dart';
import 'text_card.dart';
import 'utils.dart';

class StepGranularityDemo extends StatelessWidget {
  final bool richText;

  StepGranularityDemo(this.richText);

  @override
  Widget build(BuildContext context) {
    return AnimatedInput(
      text:
          'This String changes its size with a stepGranularity of 10. It will '
          'be automatically resized to fit on 4 lines. Now the text is so '
          'small, you can\'t even read it...',
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
                        style: TextStyle(fontSize: 40),
                        stepGranularity: 10,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      )
                    : AutoSizeText.rich(
                        spanFromString(input),
                        style: TextStyle(fontSize: 40),
                        stepGranularity: 10,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
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
