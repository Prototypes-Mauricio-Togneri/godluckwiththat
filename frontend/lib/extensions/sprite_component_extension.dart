import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';

extension ComponentExtension on SpriteComponent {
  Future<Sprite> getSprite(String path) async {
    final Image image = await Flame.images.load(path);

    return Sprite(image);
  }

  Vector2 getSize() => Vector2(
        sprite!.image.width.toDouble(),
        sprite!.image.height.toDouble(),
      );
}
