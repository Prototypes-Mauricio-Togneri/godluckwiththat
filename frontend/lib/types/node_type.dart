import 'package:tensionnode/services/assets.dart';

enum NodeType {
  coal_mine(
    sprite: Assets.IMAGES_BUILDINGS_COAL_MINE,
    productionTime: 10,
    costWood: 2,
    costStone: 0,
  ),
  cooper_mine(
    sprite: Assets.IMAGES_BUILDINGS_COOPER_MINE,
    productionTime: 10,
    costWood: 2,
    costStone: 0,
  ),
  cooper_furnace(
    sprite: Assets.IMAGES_BUILDINGS_COOPER_FURNACE,
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
