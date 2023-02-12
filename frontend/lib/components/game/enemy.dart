import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/movable_node.dart';
import 'package:tensionnode/components/game/ammo.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_enemy.dart';
import 'package:tensionnode/models/position.dart';
import 'package:tensionnode/spec/enemy_spec.dart';

class Enemy extends MovableNode with CollisionCallbacks {
  final EnemySpec spec;
  final double speed;
  final Vector2 kernelPosition;

  Enemy({
    required super.position,
    required super.shield,
    required this.spec,
    required this.kernelPosition,
  })  : speed = spec.speed * Constants.NODE_SIZE,
        super(
          type: spec.type,
          armor: spec.armor,
        );

  @override
  double get sizeMultiplier => spec.size;

  @override
  void update(double dt) {
    super.update(dt);

    _moveForward(dt);
  }

  void _moveForward(double dt) {
    final Vector2 direction = (kernelPosition - position).normalized();
    position += direction * speed * dt;
  }

  @override
  bool onComponentTypeCheck(PositionComponent other) =>
      (other is FixedNode) ||
      (other is Ammo) ||
      super.onComponentTypeCheck(other);

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is FixedNode) {
      other.contactHit(spec.damage);
      contactHit(100); // TODO(momo): what damage to give to enemy?
    } else if (other is Ammo) {
      ammoHit(other);
    }
  }

  JsonEnemy get json => JsonEnemy(
        type: type,
        position: Position.json(position),
        shield: shield.decimal(),
      );
}
