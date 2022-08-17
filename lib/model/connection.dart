import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';

class Connection {
  final Node from;
  final Node to;

  const Connection({
    required this.from,
    required this.to,
  });

  void update(double dt) {}

  void render(Renderer renderer) {
    renderer.connection(
      direction: from.directionTo(to),
      from: from.position,
      to: to.position,
      lineColor: Palette.connectionLine,
      arrowColor: Palette.connectionArrow,
    );
  }
}
