import 'package:flame/components.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/assets.dart';

class NodeSelected extends SpriteComponent with HasGameRef<GameComponent> {
  final Node node;

  NodeSelected(this.node);

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_NODE_SELECTED);
    size = getSize();
    anchor = Anchor.center;
    position = node.location.position;

    return super.onLoad();
  }
}
