part of 'auto_size_builder.dart';

class _AutoSizeElement extends RenderObjectElement {
  _AutoSizeElement(_AutoSize widget) : super(widget);

  @override
  _AutoSize get widget => super.widget as _AutoSize;

  @override
  _RenderAutoSize get renderObject => super.renderObject as _RenderAutoSize;

  Element? _text;
  Element? _replacement;
  var _overflow = false;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _replacement = updateChild(null, widget.overflowReplacement, 1);
    renderObject._buildCallback = _updateText;
  }

  @override
  void update(_AutoSize newWidget) {
    super.update(newWidget);
    _replacement = updateChild(_replacement, widget.overflowReplacement, 1);
    renderObject._buildCallback = _updateText;
    renderObject.markNeedsBuild();
  }

  @override
  void performRebuild() {
    renderObject.markNeedsBuild();
    super.performRebuild();
  }

  @override
  void unmount() {
    renderObject._buildCallback = null;
    super.unmount();
  }

  void _updateText(double textScaleFactor, bool overflow) {
    owner!.buildScope(this, () {
      _overflow = overflow;
      Widget built;
      try {
        built = widget.builder(this, textScaleFactor, overflow);
        debugWidgetBuilderValue(widget, built);
      } catch (e) {
        built = ErrorWidget(e);
      }
      try {
        _text = updateChild(_text, built, 0);
      } catch (e) {
        built = ErrorWidget(e);
        _text = updateChild(null, built, 0);
      }
    });
  }

  @override
  void insertRenderObjectChild(RenderObject child, int slot) {
    renderObject.insert(child as RenderBox,
        after: slot == 0 ? null : _text?.renderObject as RenderBox?);
  }

  @override
  void moveRenderObjectChild(RenderObject child, int oldSlot, int newSlot) {
    throw UnsupportedError('cannot move child');
  }

  @override
  void removeRenderObjectChild(RenderObject child, int slot) {
    renderObject.remove(child as RenderBox);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_text != null) visitor(_text!);
    if (_replacement != null) {
      visitor(_replacement!);
    }
  }

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    if (_overflow && _replacement != null) {
      visitor(_replacement!);
    } else {
      visitor(_text!);
    }
  }

  @override
  void forgetChild(Element child) {
    if (child == _text) {
      _text = null;
    } else {
      _replacement = null;
    }
    super.forgetChild(child);
  }
}
