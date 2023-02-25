import 'package:tensionnode/services/assets.dart';

typedef Resources = List<ResourceType>;

enum ResourceType {
  coal_ore(sprite: Assets.IMAGES_RESOURCES_COAL_ORE),
  copper_ore(sprite: Assets.IMAGES_RESOURCES_COPPER_ORE),
  copper_block(sprite: Assets.IMAGES_RESOURCES_COPPER_BLOCK);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name;
}
