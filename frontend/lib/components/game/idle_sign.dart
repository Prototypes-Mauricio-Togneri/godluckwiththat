import 'package:flame/components.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/services/assets.dart';

class IdleSign extends SpriteComponent {
  final Node node;

  IdleSign(this.node);

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_IDLE_SIGN);
    size = getSize();
    anchor = Anchor.center;
    position = node.size / 2;

    return super.onLoad();
  }
}
