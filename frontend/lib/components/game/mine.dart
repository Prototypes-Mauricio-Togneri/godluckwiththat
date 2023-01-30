import 'package:flame/input.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/dialog/contextual/mine_menu.dart';
import 'package:tensionnode/types/mine_type.dart';

class Mine extends FixedNode {
  final MineType type;
  double _accumulatedTime = 0;

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required this.type,
    required super.i,
    required super.j,
    required super.shield,
  }) : super(
          path: type.sprite,
          armor: type.armor,
        );

  @override
  void update(double dt) {
    _accumulatedTime += dt;

    if (_accumulatedTime >= type.productionTime) {
      _accumulatedTime = 0;
      game.state.addResource(type.resource);
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    if (game.state.deleteMode) {
      kill();
    } else {
      game.openMenu(
        name: MineMenu.NAME,
        node: this,
      );
    }

    return true;
  }
}
