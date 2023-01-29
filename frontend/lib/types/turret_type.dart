import 'package:tensionnode/services/assets.dart';

enum TurretType {
  light(
    path: Assets.IMAGES_TURRET_LIGHT,
    range: 75,
    damage: 20,
    fireRate: 2,
    bullets: 1,
    spread: 0,
  ),
  heavy(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    range: 75,
    damage: 20,
    fireRate: 2,
    bullets: 1,
    spread: 0,
  ),
  shotgun(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    range: 75,
    damage: 20,
    fireRate: 2,
    bullets: 4,
    spread: 25,
  ),
  sniper(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    range: 120,
    damage: 20,
    fireRate: 2,
    bullets: 1,
    spread: 0,
  ),
  machine_gun(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    range: 75,
    damage: 20,
    fireRate: 10,
    bullets: 1,
    spread: 0,
  ),
  laser(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    range: 75,
    damage: 20,
    fireRate: 2,
    bullets: 1,
    spread: 0,
  ),
  cannon(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    range: 75,
    damage: 20,
    fireRate: 2,
    bullets: 1,
    spread: 0,
  ),
  plasma(
    path: Assets.IMAGES_TURRET_LIGHT, // TODO(momo): update
    range: 75,
    damage: 20,
    fireRate: 2,
    bullets: 1,
    spread: 0,
  );

  final String path;
  final double range;
  final double damage;
  final double fireRate;
  final int bullets;
  final int spread; // in angles

  // freezer?
  // accuracy?
  // homing?
  // shatter? (upon impact, it releases smaller bullets in all directions)
  // pierces
  //    1 means that the bullet is destroyed after hitting 1 enemy
  //    3 means that it needs to hit 3 enemies before getting destroyed
  // artillery (throws bombs that detonate upon impact and damage nearby enemies)

  // type of bullet
  // shape (laser is a beam)
  // size (cannon is bigger)
  // speed
  // range (piercers should have bigger range)

  const TurretType({
    required this.path,
    required this.range,
    required this.damage,
    required this.fireRate,
    required this.bullets,
    required this.spread,
  });
}
