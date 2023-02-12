import 'package:flame/input.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/spec/mine_spec.dart';

class Mine extends FixedNode {
  final MineSpec spec;
  num _accumulatedTime = 0;

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required super.i,
    required super.j,
    required this.spec,
    required super.health,
  }) : super(type: spec.type);

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
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  JsonNode get json => JsonNode(
        type: type,
        position: [i, j],
        health: health.decimal(),
      );
}
