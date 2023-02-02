import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/weapon_spec.dart';
import 'package:tensionnode/types/node_type.dart';

class TurretSpec extends NodeSpec {
  final WeaponSpec weapon;

  static TurretSpec turret_light = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 1,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 50, green: 30, blue: 10),
  );

  static TurretSpec turret_heavy = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 2,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 50, green: 30, blue: 10),
  );

  static TurretSpec turret_shotgun = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 2,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 50, green: 30, blue: 10),
  );

  static TurretSpec turret_sniper = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 2,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 50, green: 30, blue: 10),
  );

  static TurretSpec turret_machine_gun = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 2,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 50, green: 30, blue: 10),
  );

  static TurretSpec turret_laser = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 2,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 50, green: 30, blue: 10),
  );

  static TurretSpec turret_cannon = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 2,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 50, green: 30, blue: 10),
  );

  static TurretSpec turret_plasma = TurretSpec(
    type: NodeType.turret_light,
    armor: 50,
    heat: 2,
    weapon: WeaponSpec.turret_light,
    cost: Resources(red: 50, green: 30, blue: 10),
  );

  const TurretSpec({
    required super.type,
    required super.cost,
    required super.armor,
    required super.heat,
    required this.weapon,
  });
}
