import 'package:tensionnode/services/assets.dart';

enum TurretType {
  light(path: Assets.IMAGES_TURRET_LIGHT);

  final String path;

  const TurretType({
    required this.path,
  });
}
