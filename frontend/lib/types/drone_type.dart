import 'package:tensionnode/utils/assets.dart';

enum DroneType {
  basic(
    sprite: Assets.IMAGES_DRONES_BASIC_DRONE,
    speed: 1,
  ),
  intermediate(
    sprite: Assets.IMAGES_DRONES_BASIC_DRONE,
    speed: 2,
  ),
  advance(
    sprite: Assets.IMAGES_DRONES_BASIC_DRONE,
    speed: 3,
  );

  final String sprite;
  final double speed;

  const DroneType({
    required this.sprite,
    required this.speed,
  });
}
