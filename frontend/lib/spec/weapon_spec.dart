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
    range: 50,
    fireRate: 2,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_LASER,
    bullet: BulletSpec.type1,
  );

  static WeaponSpec enemy = WeaponSpec(
    range: 30,
    fireRate: 1,
    bullets: 1,
    spread: 0,
    sound: Assets.AUDIO_SFX_BULLET,
    bullet: BulletSpec.type2,
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
