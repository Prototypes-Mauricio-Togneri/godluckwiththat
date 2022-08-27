import 'package:flutter/rendering.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/extensions/offset_extension.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class PointerHighlight {
  Offset? positionTo;
  Offset? positionFrom;
  NodeType? nodeType;

  void render(Renderer renderer) {
    if (positionTo != null) {
      if (nodeType != null) {
        if ((nodeType == NodeType.intersection) && (positionTo!.isAlignedWith(positionFrom!))) {
          renderer.drawLine(
            positionFrom: positionFrom!,
            positionTo: positionTo!,
            color: Palette.connectionLine.withAlpha(128),
          );
        } else {
          renderer.drawByType(
            type: nodeType!,
            position: positionTo!,
            color: Palette.highlightNode,
          );
        }
      } else {
        renderer.diamondFilled(
          position: positionTo!,
          color: Palette.highlightNode,
          size: renderer.map.blockSize / 5,
        );
      }
    }
  }

  void update({
    required Offset newPositionTo,
    required Offset? newPositionFrom,
    required NodeType? newNodeType,
  }) {
    positionTo = newPositionTo;
    positionFrom = newPositionFrom;
    nodeType = newNodeType;
  }
}
