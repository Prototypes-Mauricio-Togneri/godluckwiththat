import 'package:tensionnode/services/assets.dart';

enum EnemyType {
  basic(
    path: Assets.IMAGES_ENEMY,
    speed: 50,
    range: 40,
    damage: 30,
    fireRate: 1,
  );

  final String path;
  final double speed;
  final double range;
  final double damage;
  final double fireRate;

  const EnemyType({
    required this.path,
    required this.speed,
    required this.range,
    required this.damage,
    required this.fireRate,
  });
}
