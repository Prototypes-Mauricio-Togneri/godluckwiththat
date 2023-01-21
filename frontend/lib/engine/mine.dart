import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/engine/cell.dart';
import 'package:tensionnode/engine/game_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mine extends Cell with Tappable {
  final ResourceType resourceType;
  final GameState state;
  num accumulatedTime = 0;

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required super.i,
    required super.j,
    required this.resourceType,
    required this.state,
  }) : super(path: resourceType.pathMine);

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= resourceType.productionTime) {
      accumulatedTime = 0;
      state.addResource(resourceType);
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print('$i $j');

    return true;
  }
}
