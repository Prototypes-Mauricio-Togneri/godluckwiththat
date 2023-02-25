import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/services/assets.dart';

class WarningSign extends SpriteComponent {
  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_WARNING_SIGN);
    size = getSize();
    anchor = Anchor.center;
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);

    return super.onLoad();
  }
}
