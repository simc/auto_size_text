import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  final String title;
  final Widget child;

  TextCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(child: Text(title)),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: child,
            ),
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
