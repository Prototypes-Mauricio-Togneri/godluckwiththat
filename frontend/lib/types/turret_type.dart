import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/weapon_type.dart';

enum TurretType {
  light(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  heavy(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  shotgun(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  sniper(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  machine_gun(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  laser(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  cannon(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  plasma(
    path: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  );

  final String path;
  final double armor;
  final WeaponType weapon;

  const TurretType({
    required this.path,
    required this.armor,
    required this.weapon,
  });
}
