import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/blur_sprite.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/movable_node.dart';
import 'package:tensionnode/components/game/ammo.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/audio.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/spec/weapon_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class Node extends SpriteComponent
    with HasGameRef<GameComponent>, CollisionCallbacks {
  final NodeType type;
  final num armor;
  num _shield = Constants.SHIELD_MAX;
  bool _isRotating = false;
  final DebugText _debugText = DebugText();

  Node({
    required super.position,
    required this.type,
    required this.armor,
    required num shield,
  }) {
    _shield = shield;
  }

  num get shield => _shield;

  bool get isAlive => _shield > Constants.SHIELD_MIN;

  @override
  Future onLoad() async {
    sprite = await getSprite(type.spriteBase);
    size = getSize();
    anchor = Anchor.center;

    add(type.hitbox(size));
    add(BlurSprite(
      image: type.spriteBlur,
      parentSprite: this,
    ));

    /*if (Environment.isDebug) {
      add(_debugText);
    }*/

    return super.onLoad();
  }

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

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Ammo) {
      final movableShootingFixed =
          (other.shooter is MovableNode) && (this is FixedNode);
      final fixedShootingMovable =
          (other.shooter is FixedNode) && (this is MovableNode);

      if ((other.shooter != this) &&
          (movableShootingFixed || fixedShootingMovable)) {
        _hit(other);
      }
    }
  }

  void _hit(Ammo ammo) {
    game.removeFromNodesLayer(ammo);
    _shield -= ammo.spec.damage;

    if (_shield <= Constants.SHIELD_MIN) {
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
    _shield = 0;
    game.removeNode(this);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if ((_shield > Constants.SHIELD_MIN) && (_shield < Constants.SHIELD_MAX)) {
      _shield += dt * armor;
      _shield = _shield.clamp(Constants.SHIELD_MIN, Constants.SHIELD_MAX);
    }

    _debugText.text = '${_shield.toInt()}';
  }
}

class DebugText extends TextComponent {
  DebugText() {
    position = Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);
    anchor = Anchor.center;
    textRenderer = Style.debugTextRenderer(size: Constants.NODE_SIZE / 4);
  }
}
