import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/extensions/component_extension.dart';

class Cell extends SpriteComponent with HasGameRef<MyGame> {
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
    sprite = await getSprite(path);
    width = Constants.SPRITE_SIZE;
    height = Constants.SPRITE_SIZE;
    anchor = Anchor.center;

    return super.onLoad();
  }
}
