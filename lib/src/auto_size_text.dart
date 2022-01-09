import 'package:auto_size_text/src/auto_size_builder/auto_size_builder.dart';
import 'package:flutter/widgets.dart';

/// Flutter widget that automatically resizes text to fit perfectly within its
/// bounds.
///
/// All size constraints as well as maxLines are taken into account. If the text
/// overflows anyway, you should check if the parent widget actually constraints
/// the size of this
class AutoSizeText extends StatelessWidget {
  /// {@template auto_size_text.textKey}
  /// Sets the key for the resulting [Text]
  ///
  /// This allows you to find the actual `Text` widget built by `AutoSizeText`.
  /// It is useful if you want to be able to find the widget to modify it in
  /// the [State.build] method of the [StatefulWidget] that `AutoSizeText` is
  /// inserted into.
  /// {@endtemplate}
  final Key? textKey;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final String? data;

  /// {@template auto_size_text.textSpan}
  /// The text to display as a [TextSpan].
  ///
  /// This will be null if [data] is provided instead.
  /// {@endtemplate}
  final TextSpan? textSpan;

  /// {@template auto_size_text.style}
  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  /// {@endtemplate}
  final TextStyle? style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign? textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@template auto_size_text.locale}
  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  /// {@endtemplate}
  final Locale? locale;

  /// {@template auto_size_text.softWrap}
  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was
  /// unlimited horizontal space.
  /// {@endtemplate}
  final bool? softWrap;

  /// {@template auto_size_text.overflow}
  /// How visual overflow should be handled.
  ///
  /// Defaults to retrieving the value from the nearest [DefaultTextStyle] ancestor.
  /// If there is no ancestor, [TextOverflow.clip] is used.
  /// {@endtemplate}
  final TextOverflow? overflow;

  /// {@macro flutter.widgets.editableText.textScaleFactor}
  final double? textScaleFactor;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@template auto_size_text.semanticsLabel}
  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels applied
  /// directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// AutoSizeText(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@macro flutter.dart:ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@template auto_size_text.minFontSize}
  /// The minimum text size constraint to be used when auto-sizing text.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  /// {@endtemplate}
  final double? minFontSize;

  /// {@template auto_size_text.maxFontSize}
  /// The maximum text size constraint to be used when auto-sizing text.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  /// {@endtemplate}
  final double? maxFontSize;

  /// {@template auto_size_text.stepGranularity}
  /// The step size in which the font size is being adapted to constraints.
  ///
  /// The Text scales uniformly in a range between [minFontSize] and
  /// [maxFontSize].
  /// Each increment occurs as per the step size set in stepGranularity.
  ///
  /// Most of the time you don't want a stepGranularity below 1.0.
  ///
  /// Is being ignored if [presetFontSizes] is set.
  /// {@endtemplate}
  final double? stepGranularity;

  /// {@template auto_size_text.presetFontSizes}
  /// Predefines all the possible font sizes.
  ///
  /// **Important:** PresetFontSizes have to be in descending order.
  /// {@endtemplate}
  final List<double>? presetFontSizes;

  /// Synchronizes the size of multiple [AutoSizeText]s.
  ///
  /// If you want multiple [AutoSizeText]s to have the same text size, give all
  /// of them the same [AutoSizeGroup] instance. All of them will have the
  /// size of the smallest [AutoSizeText]
  //final AutoSizeGroup? group;

  /// {@template auto_size_text.wrapWords}
  /// Whether words which don't fit in one line should be wrapped.
  ///
  /// If false, the fontSize is lowered as far as possible until all words fit
  /// into a single line.
  /// {@endtemplate}
  final bool? wrapWords;

  /// {@template auto_size_text.overflowReplacement}
  /// If the text is overflowing and does not fit its bounds, this widget is
  /// displayed instead.
  /// {@endtemplate}
  final Widget? overflowReplacement;

  /// {@template auto_size_text.onOverflow}
  /// Called when the text overflows its container.
  /// {@endtemplate}
  final Function(bool overflow)? overflowCallback;

  /// Creates a [AutoSizeText]
  ///
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  const AutoSizeText(
    String this.data, {
    Key? key,
    this.textKey,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minFontSize,
    this.maxFontSize,
    this.stepGranularity,
    this.presetFontSizes,
    //this.group,
    this.wrapWords,
    this.overflowReplacement,
    this.overflowCallback,
  })  : textSpan = null,
        super(key: key);

  /// Creates a [AutoSizeText] widget with a [TextSpan].
  const AutoSizeText.rich(
    TextSpan this.textSpan, {
    Key? key,
    this.textKey,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minFontSize,
    this.maxFontSize,
    this.stepGranularity,
    this.presetFontSizes,
    //this.group,
    this.wrapWords,
    this.overflowReplacement,
    this.overflowCallback,
  })  : data = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final span = textSpan ?? TextSpan(text: data);
    return AutoSizeBuilder(
      text: span,
      style: style,
      builder: (context, scale, overflow) {
        overflowCallback?.call(overflow);
        return Text.rich(
          span,
          key: textKey,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: this.overflow,
          textScaleFactor: scale,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
        );
      },
      strutStyle: strutStyle,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      stepGranularity: stepGranularity,
      presetFontSizes: presetFontSizes,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      wrapWords: wrapWords,
      overflowReplacement: overflowReplacement,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
