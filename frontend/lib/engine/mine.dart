import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';

class Mine extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    final Image image = await Flame.images.load('red_mine.png');
    sprite = Sprite(image);
    width = 32;
    height = 32;
    anchor = Anchor.center;
    x = 0;
    y = 0;
  }
}
