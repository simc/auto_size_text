import 'package:auto_size_text/src/text_fitter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

part 'auto_size_element.dart';
part 'auto_size.dart';
part 'render_auto_size.dart';

typedef AutoSizeTextBuilder = Widget Function(
    BuildContext context, double textScaleFactor, bool overflow);

class AutoSizeBuilder extends StatefulWidget {
  const AutoSizeBuilder({
    Key? key,
    required this.builder,
    this.overflowReplacement,
    required this.text,
    this.style,
    this.textAlign,
    this.textDirection,
    this.minLines,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.wrapWords,
    this.textScaleFactor,
    this.minFontSize,
    this.maxFontSize,
    this.stepGranularity,
    this.presetFontSizes,
  }) : super(key: key);

  final AutoSizeTextBuilder builder;

  /// {@macro auto_size_text.overflowReplacement}
  final Widget? overflowReplacement;

  final TextSpan text;

  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign? textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro auto_size_text.locale}
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.dart:ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro flutter.widgets.editableText.textScaleFactor}
  final double? textScaleFactor;

  /// {@macro auto_size_text.wrapWords}
  final bool? wrapWords;

  /// {@macro auto_size_text.minFontSize}
  final double? minFontSize;

  /// {@macro auto_size_text.maxFontSize}
  final double? maxFontSize;

  /// {@macro auto_size_text.stepGranularity}
  final double? stepGranularity;

  /// {@macro auto_size_text.presetFontSizes}
  final List<double>? presetFontSizes;

  @override
  State<AutoSizeBuilder> createState() => _AutoSizeBuilderState();
}

class _AutoSizeBuilderState extends State<AutoSizeBuilder> {
  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = widget.style ?? defaultTextStyle.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }
    if (MediaQuery.boldTextOverride(context)) {
      effectiveTextStyle = effectiveTextStyle.merge(
        const TextStyle(fontWeight: FontWeight.bold),
      );
    }
    if (effectiveTextStyle.fontSize == null) {
      effectiveTextStyle = effectiveTextStyle.copyWith(fontSize: 14);
    }
    final text = TextSpan(
      text: widget.text.text,
      children: widget.text.children,
      style: effectiveTextStyle,
      locale: widget.text.locale,
    );
    return _AutoSize(
      builder: widget.builder,
      overflowReplacement: widget.overflowReplacement,
      text: text,
      textAlign:
          widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection ?? Directionality.of(context),
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
      locale: widget.locale ?? Localizations.maybeLocaleOf(context),
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior ??
          defaultTextStyle.textHeightBehavior ??
          DefaultTextHeightBehavior.of(context),
      wrapWords: widget.wrapWords ?? false,
      textScaleFactor:
          widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context),
      minFontSize: widget.minFontSize ?? 12.0,
      maxFontSize: widget.maxFontSize ?? double.infinity,
      stepGranularity: widget.stepGranularity ?? 1.0,
      presetFontSizes: widget.presetFontSizes,
    );
  }
}
