import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game.dart';

class Node extends SpriteComponent
    with HasGameRef<GameComponent>, Tappable, Hoverable {
  final int i;
  final int j;
  final String path;

  Node({
    required this.i,
    required this.j,
    required this.path,
  }) {
    position = Vector2(
      i * Constants.NODE_SIZE,
      j * Constants.NODE_SIZE,
    );
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(path);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
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
