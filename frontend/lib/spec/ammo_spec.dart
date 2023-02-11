import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/collisionable.dart';

class AmmoSpec {
  final String spriteBase;
  final String spriteBlur;
  final double damage;
  final double width;
  final double height;
  final double speed;
  final int piercing;

  static AmmoSpec type1 = const AmmoSpec(
    spriteBase: Assets.IMAGES_AMMO_1_BASE,
    spriteBlur: Assets.IMAGES_AMMO_1_BLUR,
    damage: 50,
    width: 1.5,
    height: 1.5,
    speed: 12,
    piercing: 1,
  );

  static AmmoSpec type2 = const AmmoSpec(
    spriteBase: Assets.IMAGES_AMMO_1_BASE,
    spriteBlur: Assets.IMAGES_AMMO_1_BLUR,
    damage: 30,
    width: 1.5,
    height: 1.5,
    speed: 10,
    piercing: 1,
  );

  static AmmoSpec type3 = const AmmoSpec(
    spriteBase: Assets.IMAGES_AMMO_2_BASE,
    spriteBlur: Assets.IMAGES_AMMO_2_BLUR,
    damage: 60,
    width: 1,
    height: 3,
    speed: 15,
    piercing: 1,
  );

  const AmmoSpec({
    required this.spriteBase,
    required this.spriteBlur,
    required this.damage,
    required this.width,
    required this.height,
    required this.speed,
    required this.piercing,
  });

  ShapeHitbox hitbox(Vector2 parentSize) {
    if (this == type3) {
      return Collisionable.square(parentSize);
    } else if (this == type1) {
      return Collisionable.circle(parentSize);
    } else if (this == type2) {
      return Collisionable.circle(parentSize);
    } else {
      throw Error();
    }
  }
}
