import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/types/node_type.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent>, Tappable {
  final Location location;
  final NodeType type;

  Node({
    required this.type,
    required this.location,
  });

  double get sizeMultiplier => 1;

  @override
  Future onLoad() async {
    sprite = await getSprite(type.sprite);
    size = getSize() * sizeMultiplier;
    anchor = Anchor.center;
    position = location.position;

    return super.onLoad();
  }

  @override
  bool onTapUp(TapUpInfo info) => false;

  @override
  bool onTapDown(TapDownInfo info) => false;

  void destroy() {
    game.removeNode(this);
  }
}
