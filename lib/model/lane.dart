import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';

class Lane {
  final Node from;
  final Node to;

  const Lane({
    required this.from,
    required this.to,
  });

  void render(Renderer renderer) {
    renderer.lane(
      from: from.position,
      to: to.position,
      color: Palette.white,
    );
  }
}
