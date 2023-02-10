import 'package:flame/components.dart';
import 'package:tensionnode/extensions/component_extension.dart';

class BlurSprite extends SpriteComponent {
  final String image;
  final SpriteComponent parentSprite;

  BlurSprite({
    required this.image,
    required this.parentSprite,
  });

  @override
  Future onLoad() async {
    final double parentSpriteRatio =
        parentSprite.width / parentSprite.sprite!.image.width;
    sprite = await getSprite(image);
    position = parentSprite.size / 2;
    width = sprite!.image.width * parentSpriteRatio;
    height = sprite!.image.height * parentSpriteRatio;
    anchor = Anchor.center;

    return super.onLoad();
  }
}
