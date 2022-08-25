import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class Intersection extends Node {
  Intersection({
    required super.position,
    required super.hp,
  }) : super(
          type: NodeType.intersection,
          maxHp: Constants.INTERSECTION_MAX_HP,
          energyConsumed: Constants.INTERSECTION_ENERGY,
        );

  @override
  void render(Renderer renderer) {
    renderConnections(renderer);

    renderer.drawIntersection(
      position: position,
      color: Palette.intersection,
    );

    drawHP(renderer);
    
    super.render(renderer);
  }
}
