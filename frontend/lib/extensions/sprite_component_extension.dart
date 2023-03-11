import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:tensionplanet/app/constants.dart';

extension ComponentExtension on SpriteComponent {
  Future<Sprite> getSprite(String path) async {
    final Image image = await Flame.images.load(path);

    return Sprite(image);
  }

  Vector2 getSize() {
    final double width =
        Constants.NODE_SIZE * (sprite!.image.width / Constants.BASE_IMAGE_SIZE);
    final double height = Constants.NODE_SIZE *
        (sprite!.image.height / Constants.BASE_IMAGE_SIZE);

    return Vector2(width, height);
  }
}
