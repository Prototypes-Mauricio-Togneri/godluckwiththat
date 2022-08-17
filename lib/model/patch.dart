import 'package:flutter/widgets.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch {
  final ResourceType type;
  final Offset position;

  const Patch({
    required this.type,
    required this.position,
  });

  bool isAt(Offset testPosition) => position == testPosition;

  void render(Renderer renderer) {
    renderer.squareFilled(
      position: position,
      color: type.color.withAlpha(50),
      size: renderer.map.blockSize,
    );
  }
}
