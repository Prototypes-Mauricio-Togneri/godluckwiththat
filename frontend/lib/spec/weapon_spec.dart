import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/spec/ammo_spec.dart';

class WeaponSpec {
  final double range;
  final double fireRate;
  final int bullets;
  final int spread; // in angles
  final String sound;
  final AmmoSpec ammo;

  static WeaponSpec turret_light = WeaponSpec(
    range: 5,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_AMMO2,
    ammo: AmmoSpec.type3,
  );

  static WeaponSpec turret_heavy = WeaponSpec(
    range: 6,
    fireRate: 2.2,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_AMMO2,
    ammo: AmmoSpec.type3,
  );

  static WeaponSpec turret_machine_gun = WeaponSpec(
    range: 5,
    fireRate: 8,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_AMMO1,
    ammo: AmmoSpec.type1,
  );

  const WeaponSpec({
    required this.range,
    required this.fireRate,
    required this.bullets,
    required this.spread,
    required this.sound,
    required this.ammo,
  });
}
