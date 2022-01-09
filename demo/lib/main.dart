import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'max_lines_demo.dart';
import 'min_font_size_demo.dart';
import 'overflow_replacement_demo.dart';
import 'preset_font_sizes_demo.dart';
import 'step_granularity.dart';
import 'sync_demo.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return MaterialApp(
      theme: ThemeData.light(),
      home: DemoApp(),
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

List<MaterialColor> colors = [
  Colors.red,
  Colors.purple,
  Colors.indigo,
  Colors.lightBlue,
  Colors.green,
  Colors.blueGrey,
];

List<String> demoNames = [
  'MaxLines',
  'MinFontSize',
  'Group',
  'StepGranularity',
  'PresetFontSizes',
  'OverflowReplacement',
];

class _DemoAppState extends State<DemoApp> {
  bool _richText = false;
  int _selectedDemo = 0;
  MaterialColor get _selectedColor => colors[_selectedDemo];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _richText ? 'Rich Text' : 'Normal Text',
                style: TextStyle(color: Colors.black, inherit: true),
              ),
              Switch(
                value: _richText,
                onChanged: (richText) {
                  setState(() {
                    _richText = richText;
                  });
                },
                activeColor: _selectedColor[400],
                activeTrackColor: _selectedColor[200],
              )
            ],
          ),
        ],
        title: Text(
          'AutoSizeText: ${demoNames[_selectedDemo]}',
          style: TextStyle(
            color: _selectedColor[500],
            inherit: true,
          ),
        ),
      ),
      body: Container(
        color: _selectedColor[50],
        child: Padding(
          padding: EdgeInsets.all(15),
          child: _buildDemo(),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedDemo,
        onItemSelected: (index) {
          setState(() {
            _selectedDemo = index;
          });
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.view_headline),
            title: Text('maxLines'),
            activeColor: colors[0],
          ),
          BottomNavyBarItem(
            icon: Icon(MdiIcons.formatFontSizeDecrease, size: 26),
            title: Text('minFontSize'),
            activeColor: colors[1],
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.sync, size: 26),
            title: Text('group'),
            activeColor: colors[2],
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.format_size),
            title: Text('granularity'),
            activeColor: colors[3],
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('preset'),
            activeColor: colors[4],
          ),
          BottomNavyBarItem(
            icon: Icon(MdiIcons.stackOverflow),
            title: Text('replacement'),
            activeColor: colors[5],
          ),
        ],
      ),
    );
  }

  Widget _buildDemo() {
    switch (_selectedDemo) {
      case 0:
        return MaxlinesDemo(_richText);
      case 1:
        return MinFontSizeDemo(_richText);
      case 2:
        return SyncDemo(_richText);
      case 3:
        return StepGranularityDemo(_richText);
      case 4:
        return PresetFontSizesDemo(_richText);
      default:
        return OverflowReplacementDemo(_richText);
    }
  }
}
