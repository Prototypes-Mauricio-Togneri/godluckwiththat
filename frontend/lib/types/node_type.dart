import 'package:tensionnode/services/assets.dart';

enum NodeType {
  coal_mine(
    sprite: Assets.IMAGES_BUILDINGS_COAL_MINE,
    productionTime: 3,
    costWood: 2,
    costStone: 0,
  ),
  copper_mine(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_MINE,
    productionTime: 3,
    costWood: 2,
    costStone: 0,
  ),
  copper_furnace(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_FURNACE,
    productionTime: 10,
    costWood: 2,
    costStone: 2,
  );

  final String sprite;
  final int productionTime;
  final int costWood;
  final int costStone;

  const NodeType({
    required this.sprite,
    required this.productionTime,
    required this.costWood,
    required this.costStone,
  });
}
