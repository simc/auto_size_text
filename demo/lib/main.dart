import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';

// This is just for demo purposes. The code is a bit hacky and not good style.

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _richText = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(_richText ? "Rich Text" : "Normal Text"),
                  Switch(
                    value: _richText,
                    onChanged: (richText) {
                      setState(() {
                        _richText = richText;
                      });
                    },
                    activeColor: Colors.grey.shade50,
                    inactiveTrackColor: Colors.grey.shade50.withAlpha(0x80),
                  )
                ],
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: "maxLines"),
                Tab(text: "minFontSize"),
                Tab(text: "syncGroup"),
                Tab(text: "stepGranularity"),
                Tab(text: "presetFontSizes"),
              ],
            ),
            title: Text('AutoSizeText Demo'),
          ),
          body: TabBarView(
            children: [
              DemoScreen(Demo.MaxLines, _richText),
              DemoScreen(Demo.MinFontSize, _richText),
              SyncDemo(Demo.SyncGroup.text, _richText),
              DemoScreen(Demo.StepGranularity, _richText),
              DemoScreen(Demo.PresetFontSizes, _richText),
            ],
          ),
        ),
      ),
    );
  }
}

class Demo {
  final String text;

  const Demo._(this.text);

  static const Demo MaxLines =
      Demo._("This string will be automatically resized to fit on two lines.");
  static const Demo SyncGroup = Demo._(
      "These AutoSizeTexts fit the available space and synchronize their text sizes.");
  static const Demo MinFontSize = Demo._(
      "This string's size will not be smaller than 20. It will be automatically resized to fit on 4 lines. Otherwise, the string will be ellipsized. Here is some random stuff, just to make sure it is long enough.");
  static const Demo StepGranularity = Demo._(
      "This string changes its size with a stepGranularity of 10. It will be automatically resized to fit on 4 lines. This text is so small, you can't even read it...");
  static const Demo PresetFontSizes = Demo._(
      "This string has only three allowed sizes: 40, 20 and 14. It will be automatically resized to fit on 4 lines. With this setting, you have the most control.");
}

class DemoScreen extends StatefulWidget {
  final Demo demo;
  final bool richText;

  DemoScreen(this.demo, this.richText);

  _DemoScreenState createState() => _DemoScreenState();
}

TextSpan spanFromString(String text) {
  var index = 0;
  var styles = [
    TextStyle(fontSize: 30.0),
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    TextStyle(fontSize: 40.0, fontStyle: FontStyle.italic),
  ];
  var spans = text.split(' ').map((word) {
    if (index == 3) index = 0;
    return TextSpan(
      style: styles[index++],
      text: word + " ",
    );
  }).toList();

  return TextSpan(text: "", children: spans);
}

class _DemoScreenState extends State<DemoScreen>
    with SingleTickerProviderStateMixin {
  String _input = "";

  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.demo.text.length * 80),
      vsync: this,
    );

    Animation<int> number = IntTween(
      begin: 0,
      end: widget.demo.text.length,
    ).animate(_controller);

    number.addListener(() {
      setState(() {
        _input = widget.demo.text.substring(0, number.value);
      });
    });

    number.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3), () {
          _controller.forward(from: 0.0);
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget demo;
    switch (widget.demo) {
      case Demo.MaxLines:
        demo = _buildMaxLinesDemo();
        break;
      case Demo.MinFontSize:
        demo = _buildMinFontSizeDemo();
        break;
      case Demo.StepGranularity:
        demo = _buildStepGranularityDemo();
        break;
      case Demo.PresetFontSizes:
        demo = _buildPresetFontSizesDemo();
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: demo,
          ),
        ],
      ),
    );
  }

  Widget _buildMaxLinesDemo() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextCard(
            title: "Text",
            child: Visibility(
              visible: !widget.richText,
              child: Text(
                _input,
                style: TextStyle(fontSize: 30.0),
              ),
              replacement: Text.rich(
                spanFromString(_input),
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextCard(
            title: "AutoSizeText",
            child: Visibility(
              visible: !widget.richText,
              child: AutoSizeText(
                _input,
                style: TextStyle(fontSize: 30.0),
                maxLines: 2,
              ),
              replacement: AutoSizeText.rich(
                spanFromString(_input),
                style: TextStyle(fontSize: 30.0),
                maxLines: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinFontSizeDemo() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextCard(
            title: "Text",
            child: Visibility(
              visible: !widget.richText,
              child: Text(
                _input,
                style: TextStyle(fontSize: 30.0),
                maxLines: 4,
              ),
              replacement: Text.rich(
                spanFromString(_input),
                style: TextStyle(fontSize: 30.0),
                maxLines: 4,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextCard(
            title: "AutoSizeText",
            child: Visibility(
              visible: !widget.richText,
              child: AutoSizeText(
                _input,
                style: TextStyle(fontSize: 30.0),
                minFontSize: 20.0,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              replacement: AutoSizeText.rich(
                spanFromString(_input),
                style: TextStyle(fontSize: 30.0),
                minFontSize: 20.0,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepGranularityDemo() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextCard(
            title: "Text",
            child: Visibility(
              visible: !widget.richText,
              child: Text(
                _input,
                style: TextStyle(fontSize: 40.0),
                maxLines: 4,
              ),
              replacement: Text.rich(
                spanFromString(_input),
                style: TextStyle(fontSize: 40.0),
                maxLines: 4,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextCard(
            title: "AutoSizeText",
            child: Visibility(
              visible: !widget.richText,
              child: AutoSizeText(
                _input,
                style: TextStyle(fontSize: 40.0),
                stepGranularity: 10.0,
                minFontSize: 10.0,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              replacement: AutoSizeText.rich(
                spanFromString(_input),
                style: TextStyle(fontSize: 40.0),
                stepGranularity: 10.0,
                minFontSize: 10.0,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetFontSizesDemo() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextCard(
            title: "Text",
            child: Visibility(
              visible: !widget.richText,
              child: Text(
                _input,
                style: TextStyle(fontSize: 40.0),
                maxLines: 4,
              ),
              replacement: Text.rich(
                spanFromString(_input),
                style: TextStyle(fontSize: 40.0),
                maxLines: 4,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextCard(
            title: "AutoSizeText",
            child: Visibility(
              visible: !widget.richText,
              child: AutoSizeText(
                _input,
                presetFontSizes: [40.0, 20.0, 14.0],
                maxLines: 4,
              ),
              replacement: AutoSizeText.rich(
                spanFromString(_input),
                presetFontSizes: [40.0, 20.0, 14.0],
                maxLines: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SyncDemo extends StatefulWidget {
  final String text;
  final bool richText;

  SyncDemo(this.text, this.richText);

  _SyncDemoState createState() => _SyncDemoState();
}

class _SyncDemoState extends State<SyncDemo>
    with SingleTickerProviderStateMixin {
  double _scale = 0;
  var syncGroup = AutoSizeSyncGroup();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {
        _scale = _controller.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3), () {
          _controller.forward(from: 0.1);
        });
      }
    });

    _controller.forward(from: 0.1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: TextCard(
              title: "AutoSizeText 1",
              child: Visibility(
                visible: !widget.richText,
                child: AutoSizeText(
                  widget.text,
                  syncGroup: syncGroup,
                  style: TextStyle(fontSize: 40.0),
                  maxLines: 3,
                ),
                replacement: AutoSizeText.rich(
                  spanFromString(widget.text),
                  syncGroup: syncGroup,
                  style: TextStyle(fontSize: 40.0),
                  maxLines: 4,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: ((1000 - _scale * 1000) / 2).round(),
                  child: Container(),
                ),
                Flexible(
                  flex: (_scale * 1000).round(),
                  child: TextCard(
                    title: "AutoSizeText 2",
                    child: Visibility(
                      visible: !widget.richText,
                      child: AutoSizeText(
                        widget.text,
                        syncGroup: syncGroup,
                        style: TextStyle(fontSize: 40.0),
                        maxLines: 3,
                      ),
                      replacement: AutoSizeText.rich(
                        spanFromString(widget.text),
                        syncGroup: syncGroup,
                        style: TextStyle(fontSize: 40.0),
                        maxLines: 4,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: ((1000 - _scale * 1000) / 2).round(),
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  final String title;
  final Widget child;

  TextCard({this.title, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(child: Text(title)),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: child,
            ),
            elevation: 0.0,
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
