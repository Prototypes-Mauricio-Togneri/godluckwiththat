import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game.dart';

class Resource extends SpriteComponent with HasGameRef<GameComponent> {
  final int i;
  final int j;
  final String path;

  Resource({
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
    width = Constants.CELL_SIZE / 2;
    height = Constants.CELL_SIZE / 2;
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    x += dt * 10;
  }
}
