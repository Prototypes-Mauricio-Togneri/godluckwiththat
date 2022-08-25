import 'package:flutter/services.dart';

extension RawKeyEventExtension on RawKeyEvent {
  bool isUp() => isKeyPressed(LogicalKeyboardKey.arrowUp) || (physicalKey == PhysicalKeyboardKey.keyW);

  bool isDown() => isKeyPressed(LogicalKeyboardKey.arrowDown) || (physicalKey == PhysicalKeyboardKey.keyS);

  bool isLeft() => isKeyPressed(LogicalKeyboardKey.arrowLeft) || (physicalKey == PhysicalKeyboardKey.keyA);

  bool isRight() => isKeyPressed(LogicalKeyboardKey.arrowRight) || (physicalKey == PhysicalKeyboardKey.keyD);

  bool isSpace() => (this is RawKeyUpEvent) && (isKeyPressed(LogicalKeyboardKey.space) || (physicalKey == PhysicalKeyboardKey.space));

  bool isEscape() => (this is RawKeyUpEvent) && (isKeyPressed(LogicalKeyboardKey.escape) || (physicalKey == PhysicalKeyboardKey.escape));
}
