import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/extensions/component_extension.dart';

class Cell extends SpriteComponent
    with HasGameRef<MyGame>, Tappable, Hoverable {
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
    width = Constants.CELL_SIZE;
    height = Constants.CELL_SIZE;
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  bool onTapUp(TapUpInfo info) => true;

  @override
  bool onTapDown(TapDownInfo info) => true;

  @override
  void render(Canvas canvas) {
    setOpacity(isHovered ? 0.5 : 1);

    super.render(canvas);
  }
}
