part of auto_size_text;

/// Flutter widget that automatically resizes text to fit perfectly within its bounds.
///
/// All size constraints as well as maxLines are taken into account. If the text
/// overflows anyway, you should check if the parent widget actually constraints
/// the size of this widget.
class AutoSizeText extends StatefulWidget {
  /// Creates a [AutoSizeText] widget.
  ///
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  const AutoSizeText(
    this.data, {
    Key key,
    this.style,
    this.minFontSize = 12.0,
    this.maxFontSize,
    this.stepGranularity = 1.0,
    this.presetFontSizes,
    this.syncGroup,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : assert(data != null),
        assert(minFontSize > 0),
        assert(stepGranularity >= 0.1),
        textSpan = null,
        super(key: key);

  /// Creates a [AutoSizeText] widget with a [TextSpan].
  const AutoSizeText.rich(
    this.textSpan, {
    Key key,
    this.style,
    this.minFontSize = 12.0,
    this.maxFontSize,
    this.stepGranularity = 1.0,
    this.presetFontSizes,
    this.syncGroup,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : assert(textSpan != null),
        assert(minFontSize > 0),
        assert(stepGranularity >= 0.1),
        data = null,
        super(key: key);

  /// The text to display.
  ///
  /// This will be null if a [textSpan] is provided instead.
  final String data;

  /// The text to display as a [TextSpan].
  ///
  /// This will be null if [data] is provided instead.
  final TextSpan textSpan;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle style;

  /// The minimum text size constraint to be used when auto-sizing text.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double minFontSize;

  /// The maximum text size constraint to be used when auto-sizing text.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double maxFontSize;

  /// The steps in which the font size is being adapted to constraints.
  ///
  /// The Text scales uniformly in a range between [minFontSize] and
  /// [maxFontSize].
  /// Each increment occurs as per the step size set in stepGranularity.
  ///
  /// Most of the time you don't want a stepGranularity below 1.0.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  final double stepGranularity;

  /// Lets you specify all the possible font sizes.
  ///
  /// **Important:** The presetFontSizes are used the order they are given in.
  /// If the first fontSize matches, all others are being ignored.
  final List<double> presetFontSizes;

  /// Synchronizes the size of multiple [AutoSizeText]s.
  ///
  /// If you want multiple [AutoSizeText]s to have the same text size, give all
  /// of them the same [AutoSizeSyncGroup] instance. All of them will have the
  /// size of the smallest [AutoSizeText]
  final AutoSizeSyncGroup syncGroup;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was
  /// unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  ///
  /// This property also affects [minFontSize], [maxFontSize] and [presetFontSizes].
  ///
  /// The value given to the constructor as textScaleFactor. If null, will
  /// use the [MediaQueryData.textScaleFactor] obtained from the ambient
  /// [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be resized according
  /// to the specified bounds and if necessary truncated according to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int maxLines;

  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text.
  final String semanticsLabel;

  @override
  _AutoSizeTextState createState() => _AutoSizeTextState();
}

class _AutoSizeTextState extends State<AutoSizeText> {
  double _previousFontSize;

  Text _cachedText;
  double _cachedFontSize;

  @override
  void initState() {
    super.initState();

    if (widget.syncGroup != null) {
      widget.syncGroup._register(this);
    }
  }

  @override
  void didUpdateWidget(AutoSizeText oldWidget) {
    _cachedText = null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

      TextStyle style = widget.style;
      if (widget.style == null || widget.style.inherit) {
        style = defaultTextStyle.style.merge(widget.style);
      }

      double fontSize = _calculateFontSize(size, style, defaultTextStyle);

      Text text;

      if (widget.syncGroup != null) {
        if (fontSize != _previousFontSize) {
          widget.syncGroup._updateFontSize(this, fontSize);
        }
        text = _buildText(widget.syncGroup._fontSize, style);
      } else {
        text = _buildText(fontSize, style);
      }

      _previousFontSize = fontSize;

      return text;
    });
  }

  double _calculateFontSize(
      BoxConstraints size, TextStyle style, DefaultTextStyle defaultStyle) {
    var userScale =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    var maxFontSize = (widget.maxFontSize ?? double.infinity);
    assert(widget.minFontSize <= maxFontSize,
        "MinFontSize has to be smaller or equal than maxFontSize.");

    var maxLines = widget.maxLines ?? defaultStyle.maxLines;

    int presetIndex = 0;
    if (widget.presetFontSizes != null) {
      assert(widget.presetFontSizes.isNotEmpty, "PresetFontSizes is empty.");
    }

    double initialFontSize;
    if (widget.presetFontSizes == null) {
      var current = style.fontSize;
      initialFontSize = current.clamp(widget.minFontSize, maxFontSize);
    } else {
      initialFontSize = widget.presetFontSizes[presetIndex++];
    }

    var fontSize = initialFontSize * userScale;

    var span = widget.textSpan ?? TextSpan(text: widget.data, style: style);
    while (!checkTextFits(span, widget.locale, fontSize / style.fontSize,
        maxLines, size.maxWidth, size.maxHeight)) {
      if (widget.presetFontSizes == null) {
        var newFontSize = fontSize - widget.stepGranularity;
        if (newFontSize < (widget.minFontSize * userScale)) break;
        fontSize = newFontSize;
      } else if (presetIndex < widget.presetFontSizes.length) {
        fontSize = widget.presetFontSizes[presetIndex++] * userScale;
      } else {
        break;
      }
    }

    return fontSize;
  }

  Widget _buildText(double fontSize, TextStyle style) {
    if (_cachedText != null && _cachedFontSize == fontSize) {
      return _cachedText;
    }

    Text text;
    if (widget.data != null) {
      text = Text(
        widget.data,
        style: style.copyWith(fontSize: fontSize),
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        maxLines: widget.maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    } else {
      text = Text.rich(
        widget.textSpan,
        style: style.copyWith(fontSize: fontSize),
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        maxLines: widget.maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    }

    _cachedText = text;
    _cachedFontSize = fontSize;
    return text;
  }

  void _notifySync() {
    setState(() {});
  }

  @override
  void dispose() {
    if (widget.syncGroup != null) {
      widget.syncGroup._remove(this);
    }
    super.dispose();
  }
}
