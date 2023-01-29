import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/movable_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/shooting.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/direction.dart';
import 'package:tensionnode/types/enemy_type.dart';

class Enemy extends MovableNode {
  final EnemyType type;
  final Direction direction;
  final Shooting shooting;
  Node? target;

  Enemy({
    required super.position,
    required this.type,
    required this.direction,
  })  : shooting = Shooting(type.fireRate),
        super(path: Assets.IMAGES_ENEMY);

  @override
  void update(double dt) {
    super.update(dt);

    if ((target != null) && (!target!.isAlive)) {
      target = null;
    }

    target ??= game.closestNodeInRange<FixedNode>(this, type.range);

    if (target == null) {
      _moveForward(dt);
      // TODO(momo): if passed the outer most node, remove the enemy
    } else {
      // TODO(momo): fix
      // https://www.geogebra.org/m/bAnquQpH
      // https://onlinemschool.com/math/assistance/vector/angl/
      /*final Vector2 vector = target!.position - position;
      angle = -atan2(vector.y, vector.x) * 180 / pi;
      print(position);
      print(target!.position);
      print(angle);
      print('---------');*/

      if (shooting.canShoot(dt)) {
        final Vector2 direction = (target!.position - position).normalized();
        final Vector2 originalPosition =
            position + (direction * (Constants.NODE_SIZE / 2));

        game.addBullet(
          position: originalPosition,
          direction: direction,
          range: type.range * 1.5,
          damage: type.damage,
        );
      }
    }
  }

  void _moveForward(double dt) {
    angle = 0;

    switch (direction) {
      case Direction.up:
        y -= dt * type.speed;
        break;
      case Direction.down:
        y += dt * type.speed;
        break;
      case Direction.left:
        x -= dt * type.speed;
        break;
      case Direction.right:
        x += dt * type.speed;
        break;
    }
  }
}
