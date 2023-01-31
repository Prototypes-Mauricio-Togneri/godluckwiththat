import 'package:flame/input.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/dialog/contextual/mine_menu.dart';
import 'package:tensionnode/spec/mine_spec.dart';

class Mine extends FixedNode {
  final MineSpec spec;
  double _accumulatedTime = 0;

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required super.i,
    required super.j,
    required this.spec,
    required super.shield,
  }) : super(
          image: spec.type.sprite,
          armor: spec.armor,
        );

  @override
  void update(double dt) {
    _accumulatedTime += dt;

    if (_accumulatedTime >= spec.productionTime) {
      _accumulatedTime = 0;
      game.state.addResource(spec.resource);
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
