import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/lane.dart';
import 'package:tensionnode/model/nodes/node.dart';

class Lanes {
  final List<Lane> _lanes = [];

  Lane add(Node from, Node to) => _add(
        Lane(
          from: from,
          to: to,
        ),
      );

  Lane _add(Lane element) {
    _lanes.add(element);

    return element;
  }

  void update(double dt) {
    for (final Lane lane in _lanes) {
      lane.update(dt);
    }
  }

  void render(Renderer renderer) {
    for (final Lane lane in _lanes) {
      lane.render(renderer);
    }
  }
}
