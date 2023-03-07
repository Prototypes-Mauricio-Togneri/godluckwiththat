import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/utils/assets.dart';

class IdleSign extends SpriteComponent {
  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_SIGNS_IDLE_SIGN);
    size = getSize() / 2;
    anchor = Anchor.center;
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);

    return super.onLoad();
  }
}
