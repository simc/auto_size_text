part of auto_size_text;

/// Flutter widget that automatically resizes text to fit perfectly within its bounds.
///
/// All size constraints as well as maxLines are taken into account. If the text
/// overflows anyway, you should check if the parent widget actually constraints
/// the size of this widget.
class AutoSizeText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      var userScaleFactor =
          textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
      var effectiveMaxFontSize = (maxFontSize ?? double.infinity);
      assert(minFontSize <= effectiveMaxFontSize,
          "MinFontSize has to be smaller or equal than maxFontSize.");

      DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
      TextStyle effectiveStyle = style;
      if (style == null || style.inherit)
        effectiveStyle = defaultTextStyle.style.merge(style);

      var effectiveMaxLines = maxLines ?? defaultTextStyle.maxLines;

      int presetIndex = 0;
      if (presetFontSizes != null) {
        assert(presetFontSizes.isNotEmpty, "PresetFontSizes is empty.");
      }

      double initialFontSize;
      if (presetFontSizes == null) {
        var current = effectiveStyle.fontSize;
        initialFontSize = current.clamp(minFontSize, effectiveMaxFontSize);
      } else {
        initialFontSize = presetFontSizes[presetIndex++];
      }

      var unitScale = 1 / effectiveStyle.fontSize;
      var currentScale =
          (initialFontSize * userScaleFactor) / effectiveStyle.fontSize;

      while (!_checkTextFits(currentScale, effectiveStyle, effectiveMaxLines,
          size.maxWidth, size.maxHeight)) {
        if (presetFontSizes == null) {
          var newScale = currentScale - stepGranularity * unitScale;
          var newFontSize = newScale / unitScale;
          if (newFontSize < (minFontSize * userScaleFactor)) break;
          currentScale = newScale;
        } else if (presetIndex < presetFontSizes.length) {
          currentScale =
              presetFontSizes[presetIndex++] * userScaleFactor * unitScale;
        } else {
          break;
        }
      }

      return _buildText(currentScale, effectiveStyle);
    });
  }

  Widget _buildText(double scale, TextStyle style) {
    if (data != null) {
      return Text(
        data,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: scale,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      );
    } else {
      return Text.rich(
        textSpan,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: scale,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      );
    }
  }

  bool _checkTextFits(double scale, TextStyle style, int maxLines,
      double maxWidth, double maxHeight) {
    var span = textSpan ??
        TextSpan(
          text: data,
          style: style,
        );

    var tp = TextPainter(
      text: span,
      textAlign: textAlign ?? TextAlign.left,
      textDirection: textDirection ?? TextDirection.ltr,
      textScaleFactor: scale,
      maxLines: maxLines,
      locale: locale,
    );

    tp.layout(maxWidth: maxWidth);

    return !(tp.didExceedMaxLines || tp.height > maxHeight);
  }
}
