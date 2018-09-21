import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "maxlines"),
                Tab(text: "minFontSize"),
                Tab(text: "stepGranularity"),
                Tab(text: "presetFontSizes"),
              ],
            ),
            title: Text('AutoSizeText Demo'),
          ),
          body: TabBarView(
            children: [
              DemoScreen(Demo.MaxLines),
              DemoScreen(Demo.MinFontSize),
              DemoScreen(Demo.StepGranularity),
              DemoScreen(Demo.PresetFontSizes),
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
  static const Demo MinFontSize = Demo._(
      "This string's size will not be smaller than 18. It will be automatically resized to fit on 4 lines. Otherwise, the string will be ellipsized.");
  static const Demo StepGranularity = Demo._(
      "This string changes its size with a stepGranularity of 10. It will be automatically resized to fit on 4 lines. This text is so small, you can't even read it...");
  static const Demo PresetFontSizes = Demo._(
      "This string has only three allowed sizes: 40, 20 and 14. It will be automatically resized to fit on 4 lines. With this setting, you have the most control.");
}

class DemoScreen extends StatefulWidget {
  final Demo demo;

  DemoScreen(this.demo);

  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen>
    with SingleTickerProviderStateMixin {
  String _input = "";

  @override
  void initState() {
    super.initState();

    var controller = AnimationController(
      duration: Duration(milliseconds: widget.demo.text.length * 80),
      vsync: this,
    );

    Animation<int> number = IntTween(
      begin: 0,
      end: widget.demo.text.length,
    ).animate(controller);

    number.addListener(() {
      setState(() {
        _input = widget.demo.text.substring(0, number.value);
      });
    });

    number.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3), () {
          controller.forward(from: 0.0);
        });
      }
    });

    controller.forward();
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
          child: _buildTextContainer(
            "Text",
            Text(
              _input,
              style: TextStyle(fontSize: 30.0),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: _buildTextContainer(
            "AutoSizeText",
            AutoSizeText(
              _input,
              style: TextStyle(fontSize: 30.0),
              maxLines: 2,
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
          child: _buildTextContainer(
            "Text",
            Text(
              _input,
              style: TextStyle(fontSize: 30.0),
              maxLines: 4,
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: _buildTextContainer(
            "AutoSizeText",
            AutoSizeText(
              _input,
              style: TextStyle(fontSize: 30.0),
              minFontSize: 18.0,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
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
          child: _buildTextContainer(
            "Text",
            Text(
              _input,
              style: TextStyle(fontSize: 40.0),
              maxLines: 4,
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: _buildTextContainer(
            "AutoSizeText",
            AutoSizeText(
              _input,
              style: TextStyle(fontSize: 40.0),
              stepGranularity: 10.0,
              minFontSize: 10.0,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
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
          child: _buildTextContainer(
            "Text",
            Text(
              _input,
              style: TextStyle(fontSize: 40.0),
              maxLines: 4,
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: _buildTextContainer(
            "AutoSizeText",
            AutoSizeText(
              _input,
              presetFontSizes: [40.0, 20.0, 14.0],
              maxLines: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextContainer(String title, Widget text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(child: Text(title)),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: text,
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
