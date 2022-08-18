import 'package:flutter/rendering.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class PointerHighlight {
  Offset? position;
  NodeType? nodeType;

  void render(Renderer renderer) {
    if (position != null) {
      if (nodeType != null) {
        renderer.squareHollow(
          position: position!,
          color: Palette.highlightNode,
          size: renderer.map.blockSize,
        );
  
        renderer.squareFilled(
          position: position!,
          color: Palette.highlightNode,
          size: renderer.map.blockSize / 2,
        );
      } else {
        renderer.diamondFilled(
          position: position!,
          color: Palette.highlightNode,
          size: renderer.map.blockSize / 5,
        );
      }
    }
  }

  void update({
    required Offset newPosition,
    required NodeType? newNodeType,
  }) {
    position = newPosition;
    nodeType = newNodeType;
  }
}
