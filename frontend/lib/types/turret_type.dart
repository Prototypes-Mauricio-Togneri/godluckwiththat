import 'package:tensionnode/services/assets.dart';

enum TurretType {
  light(Assets.IMAGES_TURRET);

  final String path;

  const TurretType(
    this.path,
  );
}
