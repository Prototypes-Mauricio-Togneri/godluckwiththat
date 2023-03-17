import 'package:flutter/services.dart';

extension LogicalKeyboardKeyExtension on Set<LogicalKeyboardKey> {
  bool _isKey(LogicalKeyboardKey key) => contains(key);

  bool get isEscape => _isKey(LogicalKeyboardKey.escape);

  bool get isSpace => _isKey(LogicalKeyboardKey.space);

  bool get isL => _isKey(LogicalKeyboardKey.keyL);

  bool get isControl => _isKey(LogicalKeyboardKey.controlLeft);

  bool get isUp =>
      _isKey(LogicalKeyboardKey.keyW) || _isKey(LogicalKeyboardKey.arrowUp);

  bool get isDown =>
      _isKey(LogicalKeyboardKey.keyS) || _isKey(LogicalKeyboardKey.arrowDown);

  bool get isLeft =>
      _isKey(LogicalKeyboardKey.keyA) || _isKey(LogicalKeyboardKey.arrowLeft);

  bool get isRight =>
      _isKey(LogicalKeyboardKey.keyD) || _isKey(LogicalKeyboardKey.arrowRight);

  bool get isDirectional => isUp || isDown || isLeft || isRight;
}
