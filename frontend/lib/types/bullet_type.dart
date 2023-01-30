import 'package:tensionnode/services/assets.dart';

enum BulletType {
  type1(
    path: Assets.IMAGES_LASER,
    damage: 50,
    width: 6,
    height: 2,
    speed: 100,
    range: 100,
    piercing: 1,
  ),
  type2(
    path: Assets.IMAGES_BULLET,
    damage: 30,
    width: 3,
    height: 3,
    speed: 100,
    range: 100,
    piercing: 1,
  );

  final String path;
  final double damage;
  final double width;
  final double height;
  final double speed;
  final double range;
  final int piercing;

  const BulletType({
    required this.path,
    required this.damage,
    required this.width,
    required this.height,
    required this.speed,
    required this.range,
    required this.piercing,
  });
}
