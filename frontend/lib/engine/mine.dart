import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/engine/cell.dart';
import 'package:tensionnode/engine/game_state.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mine extends Cell with Tappable {
  final ResourceType resourceType;
  final GameState gameState;
  num accumulatedTime = 0;

  static const double PRODUCTION_TIME = 1; // in seconds

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required super.i,
    required super.j,
    required this.resourceType,
    required this.gameState,
  }) : super(path: resourceType.pathMine);

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= PRODUCTION_TIME) {
      accumulatedTime = 0;
      gameState.red++;
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print('$i $j');

    return true;
  }
}
