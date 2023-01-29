import 'package:tensionnode/services/assets.dart';

enum EnemyType {
  basic(
    path: Assets.IMAGES_ENEMY,
    armor: 50,
    speed: 50,
    range: 40,
    damage: 30,
    fireRate: 1,
  );

  final String path;
  final double armor;
  final double speed;
  final double range;
  final double damage;
  final double fireRate;
  //final int bullets;
  //final int spread; // in angles

  const EnemyType({
    required this.path,
    required this.armor,
    required this.speed,
    required this.range,
    required this.damage,
    required this.fireRate,
  });
}
