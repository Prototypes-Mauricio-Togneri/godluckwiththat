import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent>, Tappable {
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
  bool onTapUp(TapUpInfo info) => false;

  @override
  bool onTapDown(TapDownInfo info) => false;
}
