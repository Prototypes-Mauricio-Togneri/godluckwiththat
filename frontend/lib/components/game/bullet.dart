import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/bullet_type.dart';

class Bullet extends SpriteComponent with HasGameRef<GameComponent> {
  final BulletType type;
  final Vector2 originalPosition;
  final Vector2 direction;

  Bullet({
    required this.type,
    required this.originalPosition,
    required this.direction,
  });

  @override
  FutureOr onLoad() async {
    position = originalPosition;
    sprite = await getSprite(type.path);
    width = type.size;
    height = type.size;
    anchor = Anchor.center;

    add(CircleHitbox());
    FlameAudio.play(Assets.AUDIO_SFX_BULLET);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _moveForward(dt);
  }

  void _moveForward(double dt) {
    position += direction * type.speed * dt;

    final double distanceFromOrigin = position.distanceTo(originalPosition);

    if (distanceFromOrigin >= type.range) {
      game.remove(this);
    }
  }
}
