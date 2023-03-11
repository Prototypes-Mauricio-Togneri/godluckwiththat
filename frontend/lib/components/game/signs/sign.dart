import 'package:flame/components.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';

class Sign extends SpriteComponent {
  final String image;

  Sign(this.image);

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    size = getSize() / 2;
    anchor = Anchor.center;
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);

    return super.onLoad();
  }
}
