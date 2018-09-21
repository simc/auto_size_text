part of auto_size_text;

/// A widget that automatically resizes text to fit perfectly within its bounds.
///
/// All size constraints as well as maxLines are taken into account. If the text
/// overflows anyway, you should check if the parent widget actually constraints
/// the size of this widget.
class AutoSizeText extends StatelessWidget {
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
    this.maxLines,
    this.semanticsLabel,
  })  : assert(data != null),
        assert(minFontSize > 0),
        assert(stepGranularity >= 0.1),
        super(key: key);

  /// The text to display.
  final String data;

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
      var effectiveMaxFontSize = maxFontSize ?? double.infinity;
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

      double startFontSize;
      if (presetFontSizes == null) {
        var current = effectiveStyle.fontSize;
        startFontSize = current.clamp(minFontSize, effectiveMaxFontSize);
      } else {
        startFontSize = presetFontSizes[presetIndex++];
      }
      var currentStyle = effectiveStyle.copyWith(fontSize: startFontSize);

      while (!_checkTextFits(
          currentStyle, effectiveMaxLines, size.maxWidth, size.maxHeight)) {
        double newFontSize;
        if (presetFontSizes == null) {
          newFontSize = currentStyle.fontSize - stepGranularity;
          if (newFontSize < minFontSize) break;
        } else {
          if (presetIndex < presetFontSizes.length)
            newFontSize = presetFontSizes[presetIndex++];
          else
            break;
        }
        currentStyle = currentStyle.copyWith(fontSize: newFontSize);
      }

      return Text(
        data,
        style: currentStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      );
    });
  }

  bool _checkTextFits(
      TextStyle style, int maxLines, double maxWidth, double maxHeight) {
    var tp = TextPainter(
      text: TextSpan(
        text: data,
        style: style,
      ),
      textAlign: textAlign ?? TextAlign.left,
      textDirection: textDirection ?? TextDirection.ltr,
      textScaleFactor: 1.0,
      maxLines: maxLines,
      locale: locale,
    );

    tp.layout(maxWidth: maxWidth);

    return !(tp.didExceedMaxLines || tp.height > maxHeight);
  }
}
