import 'package:flutter/services.dart';

extension LogicalKeyboardKeyExtension on Set<LogicalKeyboardKey> {
  bool _isKey(LogicalKeyboardKey key) => contains(key);

  bool get isEscape => _isKey(LogicalKeyboardKey.escape);
}
