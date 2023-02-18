import 'package:tensionnode/services/assets.dart';

enum NodeType {
  flag(
    sprite: Assets.IMAGES_BUILDINGS_FLAG,
    productionTime: 0,
    costWood: 0,
    costStone: 0,
  ),
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS,
    productionTime: 0,
    costWood: 0,
    costStone: 0,
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_WOODCUTTER,
    productionTime: 5,
    costWood: 2,
    costStone: 0,
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_QUARRY,
    productionTime: 10,
    costWood: 2,
    costStone: 0,
  ),
  sawmill(
    sprite: Assets.IMAGES_BUILDINGS_SAWMILL,
    productionTime: 5,
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
