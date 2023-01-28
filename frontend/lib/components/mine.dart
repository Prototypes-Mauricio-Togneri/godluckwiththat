import 'package:flame/input.dart';
import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/dialog/mine_menu.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mine extends Node {
  final ResourceType type;
  num accumulatedTime = 0;

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required super.i,
    required super.j,
    required this.type,
  }) : super(path: type.pathMine);

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= type.productionTime) {
      accumulatedTime = 0;
      game.state.addResource(type);
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    game.openMenu(
      name: MineMenu.NAME,
      node: this,
    );

    return true;
  }
}
