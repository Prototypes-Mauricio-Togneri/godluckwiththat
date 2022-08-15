import 'package:flutter/rendering.dart';
import 'package:tensionnode/model/renderer.dart';
import 'package:tensionnode/services/palette.dart';

class PointerHighlight {
  Offset? position;

  void render(Renderer renderer) {
    if (position != null) {
      renderer.diamondFilled(
        position: position!,
        color: Palette.highlightNode,
        size: renderer.blockSize / 10,
      );
    }
  }

  void setPosition(Offset newPosition) => position = newPosition;
}
