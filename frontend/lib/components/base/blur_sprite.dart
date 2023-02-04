import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';

class BlurSprite extends SpriteComponent {
  final String image;

  BlurSprite({
    required this.image,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);
    width =
        Constants.NODE_SIZE * (sprite!.image.width / Constants.BASE_IMAGE_SIZE);
    height = Constants.NODE_SIZE *
        (sprite!.image.height / Constants.BASE_IMAGE_SIZE);
    anchor = Anchor.center;

    return super.onLoad();
  }
}
