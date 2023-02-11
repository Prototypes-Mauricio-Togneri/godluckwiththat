import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/spec/bullet_spec.dart';

class WeaponSpec {
  final double range;
  final double fireRate;
  final int bullets;
  final int spread; // in angles
  final String sound;
  final BulletSpec bullet;

  static WeaponSpec turret_light = WeaponSpec(
    range: 5,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_LASER,
    bullet: BulletSpec.type1,
  );

  static WeaponSpec turret_heavy = WeaponSpec(
    range: 6,
    fireRate: 2.2,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_LASER,
    bullet: BulletSpec.type1,
  );

  static WeaponSpec turret_machine_gun = WeaponSpec(
    range: 5,
    fireRate: 8,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_LASER,
    bullet: BulletSpec.type2,
  );

  static WeaponSpec enemy1 = WeaponSpec(
    range: 4,
    fireRate: 1,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_BULLET,
    bullet: BulletSpec.type3,
  );

  static WeaponSpec enemy2 = WeaponSpec(
    range: 5,
    fireRate: 1.2,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_BULLET,
    bullet: BulletSpec.type3,
  );

  const WeaponSpec({
    required this.range,
    required this.fireRate,
    required this.bullets,
    required this.spread,
    required this.sound,
    required this.bullet,
  });
}
