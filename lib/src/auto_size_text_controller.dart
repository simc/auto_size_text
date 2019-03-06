part of auto_size_text;

class AutoSizeTextController {
  var _listeners = Map<_AutoSizeTextState, double>();
  double _fontSize = double.infinity;

  _register(_AutoSizeTextState text) {
    _listeners[text] = double.infinity;
  }

  _updateFontSize(_AutoSizeTextState text, double maxFontSize) {
    var oldFontSize = _fontSize;
    if (maxFontSize <= _fontSize) {
      _fontSize = maxFontSize;
      _listeners[text] = maxFontSize;
    } else if (_listeners[text] == _fontSize) {
      _listeners[text] = maxFontSize;
      _fontSize = double.infinity;
      for (double size in _listeners.values) {
        if (size < _fontSize) _fontSize = size;
      }
    } else {
      _listeners[text] = maxFontSize;
    }

    if (oldFontSize != _fontSize) {
      _notifyListeners();
    }
  }

  _notifyListeners() {}

  _remove(_AutoSizeTextState text) {
    _updateFontSize(text, double.infinity);
    _listeners.remove(text);
  }
}
