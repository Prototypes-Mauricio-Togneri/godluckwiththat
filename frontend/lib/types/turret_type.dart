import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/bullet_type.dart';

enum TurretType {
  light(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    range: 75,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type1,
  ),
  heavy(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    armor: 50,
    range: 75,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type1,
  ),
  shotgun(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    armor: 50,
    range: 75,
    fireRate: 2,
    bullets: 4,
    spread: 25,
    bullet: BulletType.type1,
  ),
  sniper(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    armor: 50,
    range: 120,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type1,
  ),
  machine_gun(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    armor: 50,
    range: 75,
    fireRate: 10,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type1,
  ),
  laser(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    armor: 50,
    range: 75,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type1,
  ),
  cannon(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    armor: 50,
    range: 75,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type1,
  ),
  plasma(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    armor: 50,
    range: 75,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type1,
  );

  final String path;
  final double armor;
  final double range;
  final double fireRate;
  final int bullets;
  final int spread; // in angles
  final BulletType bullet;

  const TurretType({
    required this.path,
    required this.armor,
    required this.range,
    required this.fireRate,
    required this.bullets,
    required this.spread,
    required this.bullet,
  });
}
