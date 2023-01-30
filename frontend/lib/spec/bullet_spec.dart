import 'package:tensionnode/services/assets.dart';

class BulletSpec {
  final String image;
  final double damage;
  final double width;
  final double height;
  final double speed;
  final double range;
  final int piercing;

  static BulletSpec type1 = const BulletSpec(
    image: Assets.IMAGES_LASER,
    damage: 50,
    width: 6,
    height: 2,
    speed: 100,
    range: 100,
    piercing: 1,
  );

  static BulletSpec type2 = const BulletSpec(
    image: Assets.IMAGES_BULLET,
    damage: 30,
    width: 3,
    height: 3,
    speed: 100,
    range: 100,
    piercing: 1,
  );

  const BulletSpec({
    required this.image,
    required this.damage,
    required this.width,
    required this.height,
    required this.speed,
    required this.range,
    required this.piercing,
  });
}
