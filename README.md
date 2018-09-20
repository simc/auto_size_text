# AutoSizeText

[![Travis](https://img.shields.io/travis/com/leisim/AutoSizeText/master.svg)](https://travis-ci.com/leisim/superpower) [![Version](https://img.shields.io/pub/v/auto_size_text.svg)](https://pub.dartlang.org/packages/auto_size_text) ![Runtime](https://img.shields.io/badge/dart-%3E%3D2.0-brightgreen.svg) ![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

A widget that automatically resizes text to fit perfectly within its bounds.

### Resources:
- [Documentation](https://pub.dartlang.org/documentation/auto_size_text/latest/auto_size_text/auto_size_text-library.html)
- [Pub Package](https://pub.dartlang.org/packages/auto_size_text)
- [GitHub Repository](https://github.com/leisim/auto_size_text)


![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/maxlines.gif)

## Usage

`AutoSizeText` behaves exactly like a `Text`. The only difference is that it resizes text to fit within its bounds.

```dart
AutoSizeText("The text to display",
  style: TextStyle(fontSize:20.0),
  maxlines: 2,
)
```

### maxlines

The `maxlines` parameter works like you are used to with the `Text` widget. If there is no `maxlines` parameter specified, the `AutoSizeText` only fits the text according to the available width and height.


### minFontSize & maxFontSize

With `minFontSize` you can specify the smallest possible font size. If the text still not fits, it will be handled according to `overflow`. The default `minFontSize` is 12.0.

`maxFontSize` sets the largest passible font size. This is useful if the `TextStyle` inherits the font size and you want to constrain it.

![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/minfontsize.gif)


### stepGranularity

The `AutoSizeText` will try each font size, starting with `TextStyle.fontSize` until the text fits within its bounds.  
`stepGranularity` specifies how much the font size is decreased each step. Usually, this value should not be below 1.0 for best performance.

![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/stepgranularity.gif)


### presetFontSizes

If you want to allow only specific font sizes, you can set them with `presetFontSizes`. Only font sizes which match `minFontSize` and `maxFontSize` will be used.  
If `presetFontSizes` is set, `stepGranularity` will be ignored.

![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/presetfontsizes.gif)


## Troubleshooting

If `AutoSizeText` overflows or does not resize the text, you should check if it has constraint width / height.

**Wrong** code:
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AutoSizeText("Here is a very long text, which should be resized",
          maxlines: 1,
        ),
      ],
    );
  }
}
```
Because `Row` does not constrain the width of its children, the text will overflow.

**Correct** code:
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded( // Constrains AutoSizeText to the width of the Row
          child: AutoSizeText(
            "Here is a very long text, which should be resized",
            maxlines: 1,
          )
        ),
      ],
    );
  }
}
```


## MIT License
```
Copyright (c) 2018 Simon Leier

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```