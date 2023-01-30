import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/bullet_type.dart';

enum EnemyType {
  basic(
    path: Assets.IMAGES_ENEMY,
    armor: 50,
    speed: 50,
    range: 40,
    fireRate: 1,
    bullets: 1,
    spread: 0,
    bullet: BulletType.type2,
  );

  final String path;
  final double armor;
  final double speed;
  final double range;
  final double fireRate;
  final int bullets;
  final int spread; // in angles
  final BulletType bullet;

  const EnemyType({
    required this.path,
    required this.armor,
    required this.speed,
    required this.range,
    required this.fireRate,
    required this.bullets,
    required this.spread,
    required this.bullet,
  });
}
