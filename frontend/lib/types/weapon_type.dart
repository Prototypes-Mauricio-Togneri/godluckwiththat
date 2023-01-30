import 'package:tensionnode/types/bullet_type.dart';

enum WeaponType {
  turret_light(
    range: 75,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type1,
  ),
  enemy(
    range: 40,
    fireRate: 1,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type2,
  );

  final double range;
  final double fireRate;
  final int bullets;
  final int spread; // in angles
  final BulletType bullet;

  const WeaponType({
    required this.range,
    required this.fireRate,
    required this.bullets,
    required this.spread,
    required this.bullet,
  });
}
