import 'package:flame/components.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/position.dart';
import 'package:tensionnode/services/assets.dart';

class NodeSelected extends SpriteComponent with HasGameRef<GameComponent> {
  NodeSelected({
    required FixedNode node,
  }) : super(position: Position.fromGrid(node.i, node.j));

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_NODE_SELECTED);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }
}
