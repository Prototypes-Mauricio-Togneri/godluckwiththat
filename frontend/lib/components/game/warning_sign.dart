import 'package:flame/components.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/services/assets.dart';

class WarningSign extends SpriteComponent {
  final Node node;

  WarningSign(this.node);

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_WARNING);
    size = getSize();
    anchor = Anchor.center;
    position = node.size / 2;

    return super.onLoad();
  }
}
