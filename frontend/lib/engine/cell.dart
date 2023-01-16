import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/image_composition.dart';
import 'package:tensionnode/app/constants.dart';

class Cell extends SpriteComponent {
  final int i;
  final int j;
  final String path;

  Cell({
    required this.i,
    required this.j,
    required this.path,
  }) {
    position = Vector2(
      i * Constants.CELL_SIZE,
      j * Constants.CELL_SIZE,
    );
  }

  @override
  Future onLoad() async {
    final Image image = await Flame.images.load(path);
    sprite = Sprite(image);
    width = Constants.SPRITE_SIZE;
    height = Constants.SPRITE_SIZE;
    anchor = Anchor.center;

    return super.onLoad();
  }
}
