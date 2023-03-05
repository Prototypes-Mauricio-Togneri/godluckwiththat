import 'package:tensionnode/services/assets.dart';

enum DroneType {
  construction(sprite: Assets.IMAGES_DRONES_CONSTRUCTION_DRONE),
  logistic(sprite: Assets.IMAGES_DRONES_LOGISTIC_DRONE);

  final String sprite;

  const DroneType({
    required this.sprite,
  });
}
