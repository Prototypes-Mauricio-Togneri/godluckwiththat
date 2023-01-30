import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/weapon_type.dart';

enum TurretType {
  light(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  heavy(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  shotgun(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  sniper(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  machine_gun(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  laser(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  cannon(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  ),
  plasma(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    weapon: WeaponType.turret_light,
  );

  final String image;
  final double armor;
  final WeaponType weapon;

  const TurretType({
    required this.image,
    required this.armor,
    required this.weapon,
  });
}
