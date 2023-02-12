import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/game/ammo.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/audio.dart';
import 'package:tensionnode/services/environment.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/spec/weapon_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class Node extends SpriteComponent with HasGameRef<GameComponent> {
  final NodeType type;
  num _health = 0;
  bool _isRotating = false;
  late final DebugText _debugText = DebugText();

  Node({
    required super.position,
    required this.type,
    required num health,
  }) {
    _health = health;
  }

  num get health => _health;

  bool get isAlive => _health > 0;

  @override
  Future onLoad() async {
    sprite = await getSprite(type.sprite);
    size = getSize() * sizeMultiplier;
    anchor = Anchor.center;

    add(type.hitbox(size));

    if (Environment.isDebug) {
      add(_debugText);
    }

    return super.onLoad();
  }

  double get sizeMultiplier => 1;

  void shoot({
    required WeaponSpec spec,
    required Node target,
    required double weaponRange,
  }) {
    final Vector2 direction = (target.position - position).normalized();
    final Vector2 startPosition =
        position + (direction * (Constants.NODE_SIZE / 2));

    Audio.play(spec.sound);

    game.addAmmo(
      shooter: this,
      spec: spec.ammo,
      weaponRange: weaponRange,
      startPosition: startPosition,
      direction: direction,
    );
  }

  void contactHit(double damage) {
    _health -= damage;

    if (_health <= 0) {
      destroy();
    }
  }

  void ammoHit(Ammo ammo) {
    game.removeFromNodesLayer(ammo);
    _health -= ammo.spec.damage;

    if (_health <= 0) {
      final Node shooter = ammo.shooter;

      if (shooter is Turret) {
        shooter.kills++;
      }

      destroy();
    }
  }

  void rotateTo(Vector2 targetPosition) {
    if (!_isRotating) {
      final Vector2 direction = position - targetPosition;
      final double newAngle = direction.screenAngle() + pi;
      final double angleDiff = (angle - newAngle).abs();

      if (angleDiff > 0.01) {
        _isRotating = true;
        add(
          RotateEffect.to(
            newAngle,
            LinearEffectController(0.2),
            onComplete: () {
              _isRotating = false;
            },
          ),
        );
      }
    }
  }

  void destroy() {
    _health = 0;
    game.removeNode(this);
  }
}

class DebugText extends TextComponent {
  late Node node;

  @override
  FutureOr onLoad() {
    node = parent as Node;
    position = node.size / 2;
    anchor = Anchor.center;
    textRenderer = Style.debugTextRenderer(size: Constants.NODE_SIZE / 4);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    text = '${node.health.toInt()}';
  }
}
