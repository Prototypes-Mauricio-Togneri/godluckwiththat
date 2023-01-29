import 'package:tensionnode/services/assets.dart';

enum TurretType {
  light(
    path: Assets.IMAGES_TURRET_LIGHT,
    range: 75,
    damage: 20,
    fireRate: 2,
  );

  final String path;
  final double range;
  final double damage;
  final double fireRate;

  const TurretType({
    required this.path,
    required this.range,
    required this.damage,
    required this.fireRate,
  });
}
