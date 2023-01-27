import 'package:flame/input.dart';
import 'package:tensionnode/components/cell.dart';
import 'package:tensionnode/dialog/mine_menu.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mine extends Cell {
  final ResourceType resourceType;
  num accumulatedTime = 0;

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required super.i,
    required super.j,
    required this.resourceType,
  }) : super(path: resourceType.pathMine);

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= resourceType.productionTime) {
      accumulatedTime = 0;
      game.state.addResource(resourceType);
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    game.state.selectedNode = this;
    game.openMenu(MineMenu.NAME);

    return true;
  }
}
