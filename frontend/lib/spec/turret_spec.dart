import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/weapon_type.dart';

class TurretSpec extends NodeSpec {
  final WeaponType weapon;

  static TurretSpec turret_light = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    weapon: WeaponType.turret_light,
    cost: Resources(),
  );
  /*heavy(
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
  );*/

  const TurretSpec({
    required super.type,
    required super.cost,
    required super.armor,
    required this.weapon,
  });
}
