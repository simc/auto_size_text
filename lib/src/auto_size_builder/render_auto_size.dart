part of 'auto_size_builder.dart';

class _AutoSizeParentData extends ParentData
    with ContainerParentDataMixin<RenderBox> {}

class _RenderAutoSize extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox,
            ContainerParentDataMixin<RenderBox>> {
  _RenderAutoSize({required TextFitter fitter}) : _fitter = fitter;

  var _overflow = false;
  var _needsBuild = true;
  double? _previousTextScaleFactor;
  bool? _previousOverflow;
  double? _longestWordWidth;

  Function(double, bool)? _buildCallback;
  set buildCallback(Function(double, bool)? buildCallback) {
    if (_buildCallback == buildCallback) return;
    _previousTextScaleFactor = null;
    _buildCallback = buildCallback;
    markNeedsLayout();
  }

  TextFitter _fitter;
  set textFitter(TextFitter fitter) {
    if (_fitter == fitter) return;
    if (_fitter.text != fitter.text) {
      _longestWordWidth = null;
    }
    _previousTextScaleFactor = null;
    _fitter = fitter;
    markNeedsLayout();
  }

  RenderBox get child => _overflow ? lastChild! : firstChild!;

  bool get hasReplacement => !identical(firstChild, lastChild);

  void markNeedsBuild() {
    _needsBuild = true;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! ListWheelParentData) {
      child.parentData = _AutoSizeParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final result =
        _fitter.fit(BoxConstraints.tightFor(height: height), _longestWordWidth);
    _longestWordWidth = result.longestWordWidth;

    if (result.overflow && hasReplacement) {
      return child.getMinIntrinsicWidth(height);
    } else {
      return result.minIntrinsicWidth;
    }
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final result =
        _fitter.fit(BoxConstraints.tightFor(height: height), _longestWordWidth);
    _longestWordWidth = result.longestWordWidth;

    if (result.overflow && hasReplacement) {
      return lastChild!.getMaxIntrinsicWidth(height);
    } else {
      return result.maxIntrinsicWidth;
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final result =
        _fitter.fit(BoxConstraints.tightFor(width: width), _longestWordWidth);
    _longestWordWidth = result.longestWordWidth;

    if (result.overflow && hasReplacement) {
      return lastChild!.getMinIntrinsicHeight(width);
    } else {
      return result.size.height;
    }
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final result =
        _fitter.fit(BoxConstraints.tightFor(width: width), _longestWordWidth);
    _longestWordWidth = result.longestWordWidth;

    if (result.overflow && hasReplacement) {
      return lastChild!.getMaxIntrinsicHeight(width);
    } else {
      return result.size.height;
    }
  }

  @override
  void performLayout() {
    final constraints = this.constraints;

    final result = _fitter.fit(constraints, _longestWordWidth);
    _longestWordWidth = result.longestWordWidth;

    if (_needsBuild ||
        result.scale != _previousTextScaleFactor ||
        result.overflow != _previousOverflow) {
      _previousTextScaleFactor = result.scale;
      _previousOverflow = result.overflow;
      _needsBuild = false;
      invokeLayoutCallback(
          (_) => _buildCallback!(result.scale, result.overflow));
    }

    _overflow = result.overflow;
    firstChild!.layout(constraints, parentUsesSize: true);
    if (hasReplacement) {
      lastChild!.layout(constraints, parentUsesSize: true);
    }
    size = constraints.constrain(child.size);
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return child.computeDistanceToActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child.hitTest(result, position: position);
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child, offset);
  }
}
