# AutoSizeText

[![Travis](https://img.shields.io/travis/com/leisim/auto_size_text/master.svg)](https://travis-ci.com/leisim/auto_size_text) [![codecov](https://codecov.io/gh/leisim/auto_size_text/branch/master/graph/badge.svg)](https://codecov.io/gh/leisim/auto_size_text) [![Version](https://img.shields.io/pub/v/auto_size_text.svg)](https://pub.dartlang.org/packages/auto_size_text) ![Runtime](https://img.shields.io/badge/dart-%3E%3D2.0-brightgreen.svg) ![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

Flutter widget that automatically resizes text to fit perfectly within its bounds.

**Show some ❤️ and star the repo to support the project**

### Resources:
- [Documentation](https://pub.dartlang.org/documentation/auto_size_text/latest/auto_size_text/AutoSizeText-class.html)
- [Pub Package](https://pub.dartlang.org/packages/auto_size_text)
- [GitHub Repository](https://github.com/leisim/auto_size_text)

Also check out the [superpower](https://github.com/leisim/superpower) plugin 🦄


![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/maxlines.gif)

## Usage

`AutoSizeText` behaves exactly like a `Text`. The only difference is that it resizes text to fit within its bounds.

```dart
AutoSizeText(
  "The text to display",
  style: TextStyle(fontSize: 20.0),
  maxLines: 2,
)
```

### maxLines

The `maxLines` parameter works like you are used to with the `Text` widget. If there is no `maxLines` parameter specified, the `AutoSizeText` only fits the text according to the available width and height.

```dart
AutoSizeText(
  "A really long String",
  style: TextStyle(fontSize: 30.0),
  maxLines: 2,
)
```

*Sample above*


### minFontSize & maxFontSize

The `AutoSizeText` starts with `TextStyle.fontSize`. It measures the resulting text and rescales it to fit within its bonds. You can however set the allowed range of the resulting font size.

With `minFontSize` you can specify the smallest possible font size. If the text still doesn't fit, it will be handled according to `overflow`. The default `minFontSize` is 12.0.

`maxFontSize` sets the largest possible font size. This is useful if the `TextStyle` inherits the font size and you want to constrain it.

```dart
AutoSizeText(
  "A really long String",
  style: TextStyle(fontSize: 30.0),
  minFontSize: 18.0,
  maxLines: 4,
  overflow: TextOverflow.ellipsis,
)
```

![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/minfontsize.gif)


### stepGranularity

The `AutoSizeText` will try each font size, starting with `TextStyle.fontSize` until the text fits within its bounds.  
`stepGranularity` specifies how much the font size is decreased each step. Usually, this value should not be below 1.0 for best performance.

```dart
AutoSizeText(
  "A really long String",
  style: TextStyle(fontSize: 40.0),
  minFontSize: 10.0,
  stepGranularity: 10.0,
  maxLines: 4,
  overflow: TextOverflow.ellipsis,
)
```

![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/stepgranularity.gif)


### presetFontSizes

If you want to allow only specific font sizes, you can set them with `presetFontSizes`.
If `presetFontSizes` is set, `minFontSize`, `maxFontSize` and `stepGranularity` will be ignored.

```dart
AutoSizeText(
  "A really long String",
  presetFontSizes: [40.0, 20.0, 14.0],
  maxLines: 4,
)
```

![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/presetfontsizes.gif)


## Rich Text

You can also use Rich Text (like different text styles or links) with `AutoSizeText`. Just use the `AutoSizeText.rich()` constructor
(which works exactly like the `Text.rich()` constructor).

The only thing you have to be aware of is how the font size calculation works: The `fontSize` in the `style`
parameter of `AutoSizeText` (or the inherited `fontSize` if none is set) is used as reference.  

For example:
```dart
AutoSizeText.rich(
  TextSpan(text: "A really long String"),
  style: TextStyle(fontSize: 20.0),
  minFontSize: 5.0,
)
```
The text will be at least 1/4 of its original size (5 / 20 = 1/4).  
But it does not mean that all `TextSpan`s have at least font size 5.0.

![](https://raw.githubusercontent.com/leisim/auto_size_text/master/screenshots/maxlines_rich.gif)


## Performance

`AutoSizeText` is really fast. Nevertheless you should not use an unreasonable high `fontSize` in your `TextStyle`. E.g. don't set the `fontSize` to `1000.0` if you know, that the text will never be larger than `30.0`.

If your font size has a large range, consider increasing `stepGranularity`.


## Troubleshooting

If `AutoSizeText` overflows or does not resize the text, you should check if it has constraint width / height.

**Wrong** code:
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AutoSizeText(
          "Here is a very long text, which should be resized",
          maxLines: 1,
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
            maxLines: 1,
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