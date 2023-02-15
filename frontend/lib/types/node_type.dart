import 'package:tensionnode/services/assets.dart';

enum NodeType {
  headquarters(
    sprite: Assets.IMAGES_HEADQUARTERS,
    productionTime: 0,
    costWood: 0,
    costStone: 0,
  ),
  woodcutter(
    sprite: Assets.IMAGES_WOODCUTTER,
    productionTime: 0,
    costWood: 2,
    costStone: 0,
  ),
  quarry(
    sprite: Assets.IMAGES_QUARRY,
    productionTime: 0,
    costWood: 2,
    costStone: 0,
  ),
  sawmill(
    sprite: Assets.IMAGES_SAWMILL,
    productionTime: 0,
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
