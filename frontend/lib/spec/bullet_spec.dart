import 'package:tensionnode/services/assets.dart';

class BulletSpec {
  final String sprite;
  final double damage;
  final double width;
  final double height;
  final double speed;
  final double range;
  final int piercing;

  static BulletSpec type1 = const BulletSpec(
    sprite: Assets.IMAGES_LASER_BASE,
    damage: 60,
    width: 1,
    height: 3,
    speed: 6,
    range: 2,
    piercing: 1,
  );

  static BulletSpec type2 = const BulletSpec(
    sprite: Assets.IMAGES_BULLET_BASE,
    damage: 30,
    width: 1.5,
    height: 1.5,
    speed: 6,
    range: 2,
    piercing: 1,
  );

  const BulletSpec({
    required this.sprite,
    required this.damage,
    required this.width,
    required this.height,
    required this.speed,
    required this.range,
    required this.piercing,
  });
}
