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
    productionTime: 1,
    costWood: 2,
    costStone: 0,
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_QUARRY,
    productionTime: 1,
    costWood: 2,
    costStone: 0,
  ),
  well(
    sprite: Assets.IMAGES_BUILDINGS_WELL,
    productionTime: 1,
    costWood: 2,
    costStone: 0,
  ),
  fisher(
    sprite: Assets.IMAGES_BUILDINGS_FISHER,
    productionTime: 1,
    costWood: 2,
    costStone: 0,
  ),
  hunter(
    sprite: Assets.IMAGES_BUILDINGS_HUNTER,
    productionTime: 1,
    costWood: 2,
    costStone: 0,
  ),
  crop_farm(
    sprite: Assets.IMAGES_BUILDINGS_CROP_FARM,
    productionTime: 1,
    costWood: 3,
    costStone: 3,
  ),
  mill(
    sprite: Assets.IMAGES_BUILDINGS_MILL,
    productionTime: 1,
    costWood: 2,
    costStone: 2,
  ),
  bakery(
    sprite: Assets.IMAGES_BUILDINGS_BAKERY,
    productionTime: 1,
    costWood: 2,
    costStone: 2,
  ),
  sawery(
    sprite: Assets.IMAGES_BUILDINGS_SAWERY,
    productionTime: 1,
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

  bool get canBeBuilt => (this != flag) && (this != headquarters);
}
