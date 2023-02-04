import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/extensions/component_extension.dart';
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
    width = Constants.SELECTED_SIZE;
    height = Constants.SELECTED_SIZE;
    anchor = Anchor.center;

    return super.onLoad();
  }
}
