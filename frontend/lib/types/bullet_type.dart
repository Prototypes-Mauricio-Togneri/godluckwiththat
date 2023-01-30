import 'package:tensionnode/services/assets.dart';

enum BulletType {
  type1(
    image: Assets.IMAGES_LASER,
    damage: 50,
    width: 6,
    height: 2,
    speed: 100,
    range: 100,
    piercing: 1,
  ),
  type2(
    image: Assets.IMAGES_BULLET,
    damage: 30,
    width: 3,
    height: 3,
    speed: 100,
    range: 100,
    piercing: 1,
  );

  final String image;
  final double damage;
  final double width;
  final double height;
  final double speed;
  final double range;
  final int piercing;

  const BulletType({
    required this.image,
    required this.damage,
    required this.width,
    required this.height,
    required this.speed,
    required this.range,
    required this.piercing,
  });
}
