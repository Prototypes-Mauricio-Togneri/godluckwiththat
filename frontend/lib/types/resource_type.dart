import 'package:tensionnode/services/assets.dart';

typedef Resources = List<ResourceType>;

enum ResourceType {
  coal_ore(sprite: Assets.IMAGES_RESOURCES_COAL_ORE),
  cooper_ore(sprite: Assets.IMAGES_RESOURCES_COOPER_ORE),
  cooper_block(sprite: Assets.IMAGES_RESOURCES_COOPER_BLOCK);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name;
}
