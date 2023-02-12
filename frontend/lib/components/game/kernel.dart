import 'package:flame/events.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';

class Kernel extends FixedNode {
  Kernel({
    required super.i,
    required super.j,
    required super.health,
  }) : super(type: FixedNodeSpec.kernel.type);

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }

  JsonNode get json => JsonNode(
        type: type,
        position: [i, j],
        health: health.decimal(),
      );
}
