import 'dart:math';

import 'package:flutter/widgets.dart';

const _kDefaultFontSize = 14;

class TextFitter {
  TextFitter({
    required this.text,
    required this.textAlign,
    required this.textDirection,
    this.minLines,
    this.maxLines,
    this.locale,
    this.strutStyle,
    required this.textWidthBasis,
    this.textHeightBehavior,
    this.wrapWords = false,
    this.textScaleFactor = 1.0,
    required this.minFontSize,
    required this.maxFontSize,
    this.stepGranularity = 1.0,
    this.presetFontSizes,
  });

  final TextSpan text;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final int? minLines;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final bool wrapWords;
  final double textScaleFactor;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;

  double? _longestWordWidth;

  TextFitResult fit(BoxConstraints constraints, [double? longestWordWidth]) {
    int left;
    int right;

    if (longestWordWidth != null) {
      _longestWordWidth = longestWordWidth;
    }

    final fontSize = text.style?.fontSize ?? _kDefaultFontSize;
    final presetFontSizes = this.presetFontSizes?.reversed.toList();
    if (presetFontSizes == null) {
      final defaultFontSize = fontSize.clamp(minFontSize, maxFontSize);
      final defaultScale = defaultFontSize * textScaleFactor / fontSize;
      final result = _measureText(defaultScale, constraints);
      if (!result.overflow) {
        return result;
      }

      left = (minFontSize / stepGranularity).floor();
      right = (defaultFontSize / stepGranularity).ceil();
    } else {
      left = 0;
      right = presetFontSizes.length - 1;
    }

    TextFitResult? lastFitting;
    while (left <= right) {
      final mid = (left + (right - left) / 2).floor();
      double scale;
      if (presetFontSizes == null) {
        scale = mid * textScaleFactor * stepGranularity / fontSize;
      } else {
        scale = presetFontSizes[mid] * textScaleFactor / fontSize;
      }
      final result = _measureText(scale, constraints);
      if (result.overflow) {
        right = mid - 1;
      } else {
        left = mid + 1;
      }
      if (lastFitting == null || !result.overflow) {
        lastFitting = result;
      }
    }

    if (lastFitting!.overflow) {
      right += 1;
    }

    double scale;
    if (presetFontSizes == null) {
      scale = right * textScaleFactor * stepGranularity / fontSize;
    } else {
      scale = presetFontSizes[right] * textScaleFactor / fontSize;
    }

    return lastFitting.copyWith(scale: scale);
  }

  TextFitResult _measureText(double scale, BoxConstraints constraints) {
    if (!wrapWords && _longestWordWidth == null) {
      final wordWrapTextPainter = TextPainter(
        text: TextSpan(children: _getWordSpans()),
        textAlign: textAlign,
        textDirection: textDirection,
        textScaleFactor: 1,
        maxLines: null,
        ellipsis: null,
        locale: locale,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      );

      wordWrapTextPainter.layout();
      _longestWordWidth = wordWrapTextPainter.width;
    }

    final scaledLongestWordWidth =
        (!wrapWords ? _longestWordWidth! : 0) * scale;

    final textPainter = TextPainter(
      text: text,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: scale,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );

    textPainter.layout(maxWidth: constraints.maxWidth);

    final overflow = textPainter.didExceedMaxLines ||
        textPainter.preferredLineHeight * (minLines ?? 0) >
            constraints.maxHeight ||
        textPainter.height > constraints.maxHeight ||
        textPainter.width > constraints.maxWidth ||
        scaledLongestWordWidth > constraints.maxWidth;

    return TextFitResult(
      scale: scale,
      overflow: overflow,
      size: Size(
        max(textPainter.width, scaledLongestWordWidth),
        textPainter.height,
      ),
      minIntrinsicWidth: max(
        textPainter.minIntrinsicWidth,
        scaledLongestWordWidth,
      ),
      maxIntrinsicWidth: max(
        textPainter.maxIntrinsicWidth,
        scaledLongestWordWidth,
      ),
      longestWordWidth: _longestWordWidth,
    );
  }

  List<TextSpan> _getWordSpans() {
    final wordRegex = RegExp('\\s+');
    Iterable<TextSpan> splitSpan(TextSpan span, TextStyle? style) sync* {
      final mergedStyle = span.style?.merge(style) ?? style;
      if (span.text != null) {
        final words = span.text!.split(wordRegex);
        for (var word in words) {
          yield TextSpan(
            text: '$word\n',
            style: mergedStyle,
          );
        }
      } else if (span.children != null) {
        for (var child in span.children!) {
          if (child is TextSpan) {
            yield* splitSpan(child, mergedStyle);
          }
        }
      }
    }

    return splitSpan(text, null).toList();
  }

  @override
  operator ==(Object other) {
    return other is TextFitter &&
        other.text == text &&
        other.textAlign == textAlign &&
        other.textDirection == textDirection &&
        other.maxLines == maxLines &&
        other.locale == locale &&
        other.strutStyle == strutStyle &&
        other.textWidthBasis == textWidthBasis &&
        other.textHeightBehavior == textHeightBehavior &&
        other.wrapWords == wrapWords &&
        other.textScaleFactor == textScaleFactor &&
        other.minFontSize == minFontSize &&
        other.maxFontSize == maxFontSize &&
        other.stepGranularity == stepGranularity &&
        other.presetFontSizes == presetFontSizes;
  }

  @override
  int get hashCode {
    return hashValues(
      text,
      textAlign,
      textDirection,
      maxLines,
      locale,
      strutStyle,
      textWidthBasis,
      textHeightBehavior,
      wrapWords,
      textScaleFactor,
      minFontSize,
      maxFontSize,
      stepGranularity,
      presetFontSizes,
    );
  }
}

class TextFitResult {
  TextFitResult({
    required this.scale,
    required this.overflow,
    required this.size,
    required this.minIntrinsicWidth,
    required this.maxIntrinsicWidth,
    required this.longestWordWidth,
  });

  final double scale;
  final bool overflow;
  final Size size;
  final double minIntrinsicWidth;
  final double maxIntrinsicWidth;
  final double? longestWordWidth;

  TextFitResult copyWith({required double scale}) {
    return TextFitResult(
      scale: scale,
      overflow: overflow,
      size: size,
      minIntrinsicWidth: minIntrinsicWidth,
      maxIntrinsicWidth: maxIntrinsicWidth,
      longestWordWidth: longestWordWidth,
    );
  }
}
