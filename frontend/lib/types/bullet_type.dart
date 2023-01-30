import 'package:tensionnode/services/assets.dart';

enum BulletType {
  type1(
    path: Assets.IMAGES_LASER,
    damage: 50,
    size: 3,
    speed: 100,
    range: 100,
    piercing: 1,
  ),
  type2(
    path: Assets.IMAGES_BULLET,
    damage: 30,
    size: 3,
    speed: 100,
    range: 100,
    piercing: 1,
  );

  final String path;
  final double damage;
  final double size;
  final double speed;
  final double range;
  final int piercing;

  const BulletType({
    required this.path,
    required this.damage,
    required this.size,
    required this.speed,
    required this.range,
    required this.piercing,
  });
}
