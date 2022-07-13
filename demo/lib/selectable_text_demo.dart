library selectable_text_demo.dart;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'animated_input.dart';
import 'text_card.dart';
import 'utils.dart';

/// A stateful widget to render SelectableTextDemo.
class SelectableTextDemo extends StatelessWidget {
  const SelectableTextDemo(this.richText, {Key? key}) : super(key: key);

  final bool richText;

  @override
  Widget build(BuildContext context) {
    return AnimatedInput(
      text: '"AutoSizeText.selectable" & "AutoSizeText.richSelectable"'
          ' widgets displays a string of text with a single style'
          ' or paragraphs with differently styled TextSpans.'
          ' It is similar to "SelectableText" & "SelectableText.rich", but uses AutoSizeText to render.',
      builder: (input) {
        return Row(
          children: <Widget>[
            Expanded(
              child: TextCard(
                title: 'AutoSizeText',
                child: !richText
                    ? AutoSizeText(
                        input,
                        style: TextStyle(fontSize: 30),
                      )
                    : AutoSizeText.rich(
                        spanFromString(input),
                        style: TextStyle(fontSize: 30),
                      ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextCard(
                title: 'AutoSizeText.selectable',
                child: !richText
                    ? AutoSizeText.selectable(
                        input,
                        style: TextStyle(fontSize: 30),
                        maxLines: 2,
                      )
                    : AutoSizeText.richSelectable(
                        spanFromString(input),
                        style: TextStyle(fontSize: 30),
                        maxLines: 2,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
