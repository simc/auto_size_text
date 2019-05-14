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
    this.group,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = false,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : assert(data != null,
            'A non-null String must be provided to a AutoSizeText widget.'),
        assert(stepGranularity >= 0.1,
            'StepGranularity has to be greater than or equal to 0.1.'),
        assert(minFontSize == null || minFontSize >= 0,
            "MinFontSize has to be greater than or equal to 0."),
        assert(maxFontSize == null || maxFontSize > 0,
            "MaxFontSize has to be greater than 0."),
        assert(overflow == null || overflowReplacement == null,
            'Either overflow or overflowReplacement have to be null.'),
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
    this.group,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = false,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  : assert(textSpan != null,
            'A non-null TextSpan must be provided to a AutoSizeText.rich widget.'),
        assert(stepGranularity >= 0.1,
            'StepGranularity has to be greater than or equal to 0.1.'),
        assert(minFontSize == null || minFontSize >= 0,
            "MinFontSize has to be greater than or equal to 0."),
        assert(maxFontSize == null || maxFontSize > 0,
            "MaxFontSize has to be greater than 0."),
        assert(overflow == null || overflowReplacement == null,
            'Either overflow or overflowReplacement have to be null.'),
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
  /// **Important:** PresetFontSizes have to be in descending order.
  final List<double> presetFontSizes;

  /// Synchronizes the size of multiple [AutoSizeText]s.
  ///
  /// If you want multiple [AutoSizeText]s to have the same text size, give all
  /// of them the same [AutoSizeGroup] instance. All of them will have the
  /// size of the smallest [AutoSizeText]
  final AutoSizeGroup group;

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

  /// Whether words which don't fit in one line should be wrapped.
  ///
  /// If false, the fontSize is lowered as far as possible until all words fit
  /// into a single line.
  final bool wrapWords;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// If the text is overflowing and does not fit its bounds, this widget is
  /// displayed instead.
  final Widget overflowReplacement;

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

    if (widget.group != null) {
      widget.group._register(this);
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

      var result = _calculateFontSize(size, style, defaultTextStyle);
      var fontSize = result[0];
      var textFits = result[1];

      Text text;

      if (widget.group != null) {
        if (fontSize != _previousFontSize) {
          widget.group._updateFontSize(this, fontSize);
        }
        text = _buildText(widget.group._fontSize, style);
      } else {
        text = _buildText(fontSize, style);
      }

      _previousFontSize = fontSize;

      if (widget.overflowReplacement != null && !textFits) {
        return widget.overflowReplacement;
      } else {
        return text;
      }
    });
  }

  List _calculateFontSize(
      BoxConstraints size, TextStyle style, DefaultTextStyle defaultStyle) {
    var span = TextSpan(
      style: widget.textSpan?.style ?? style,
      text: widget.textSpan?.text ?? widget.data,
      children: widget.textSpan?.children,
      recognizer: widget.textSpan?.recognizer,
    );

    var maxLines = widget.maxLines ?? defaultStyle.maxLines;

    int left;
    int right;

    var presetFontSizes = widget.presetFontSizes?.reversed?.toList();

    if (presetFontSizes == null) {
      var minFontSize = widget.minFontSize ?? 0;
      var maxFontSize = widget.maxFontSize ?? double.infinity;
      assert(minFontSize <= maxFontSize,
          "MinFontSize has to be smaller or equal than maxFontSize.");
      assert(minFontSize / widget.stepGranularity % 1 < 0.00001,
          "MinFontSize has to be multiples of stepGranularity.");
      if (widget.maxFontSize != null) {
        assert(maxFontSize / widget.stepGranularity % 1 < 0.00001,
            "MaxFontSize has to be multiples of stepGranularity.");
      }
      assert(style.fontSize / widget.stepGranularity % 1 < 0.00001,
          "FontSize has to be multiples of stepGranularity.");

      left = (minFontSize / widget.stepGranularity).round();
      var initialFontSize = style.fontSize.clamp(minFontSize, maxFontSize);
      right = (initialFontSize / widget.stepGranularity).round();
    } else {
      assert(presetFontSizes.isNotEmpty, "PresetFontSizes has to be nonempty.");

      left = 0;
      right = presetFontSizes.length - 1;
    }

    var userScale =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    bool lastValueFits = false;
    while (left <= right) {
      int mid = (left + (right - left) / 2).toInt();
      double scale;

      if (presetFontSizes == null) {
        scale = mid * userScale / style.fontSize;
      } else {
        scale = presetFontSizes[mid] * userScale / style.fontSize;
      }

      if (_checkTextFitsAndWordWrap(span, scale, size, maxLines)) {
        left = mid + 1;
        lastValueFits = true;
      } else {
        right = mid - 1;
        lastValueFits = false;
      }
    }

    if (presetFontSizes == null) {
      return [((left - 1) * userScale * widget.stepGranularity), lastValueFits];
    } else {
      return [presetFontSizes[left - 1] * userScale, lastValueFits];
    }
  }

  bool _checkTextFitsAndWordWrap(
      TextSpan span, double scale, BoxConstraints size, int maxLines) {
    var textFits = checkTextFits(
      span,
      widget.locale,
      scale,
      maxLines,
      size.maxWidth,
      size.maxHeight,
    );
    if (textFits) {
      if (widget.wrapWords) {
        return !checkWordsWrapping(span, widget.locale, scale, size.maxWidth);
      } else {
        return true;
      }
    } else {
      return false;
    }
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
        textScaleFactor: 1,
        maxLines: widget.maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    } else {
      text = Text.rich(
        widget.textSpan,
        style: style,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: fontSize / style.fontSize,
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
    if (widget.group != null) {
      widget.group._remove(this);
    }
    super.dispose();
  }
}
