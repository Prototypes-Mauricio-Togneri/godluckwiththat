import 'package:tensionnode/services/assets.dart';

enum DroneType {
  construction(
    sprite: Assets.IMAGES_DRONES_CONSTRUCTION_DRONE,
    speed: 1,
  ),
  logistic(
    sprite: Assets.IMAGES_DRONES_LOGISTIC_DRONE,
    speed: 1,
  );

  final String sprite;
  final double speed;

  const DroneType({
    required this.sprite,
    required this.speed,
  });
}
