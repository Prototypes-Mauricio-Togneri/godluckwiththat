import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/resource_type.dart';

enum MineType {
  red(
    sprite: Assets.IMAGES_MINE_RED,
    armor: 20,
    productionTime: 1,
    resource: ResourceType.red,
  ),
  green(
    sprite: Assets.IMAGES_MINE_GREEN,
    armor: 20,
    productionTime: 2,
    resource: ResourceType.green,
  ),
  blue(
    sprite: Assets.IMAGES_MINE_BLUE,
    armor: 20,
    productionTime: 3,
    resource: ResourceType.blue,
  );

  final String sprite;
  final double armor;
  final int productionTime;
  final ResourceType resource;

  const MineType({
    required this.sprite,
    required this.armor,
    required this.productionTime,
    required this.resource,
  });
}
