import 'package:tensionnode/services/assets.dart';

enum TurretType {
  light(
    path: Assets.IMAGES_TURRET_LIGHT,
    range: 75,
    damage: 20,
  );

  final String path;
  final double range;
  final double damage;

  const TurretType({
    required this.path,
    required this.range,
    required this.damage,
  });
}
