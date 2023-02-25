import 'package:tensionnode/services/assets.dart';

typedef Resources = List<ResourceType>;

enum ResourceType {
  coal_ore(sprite: Assets.IMAGES_RESOURCES_TIMBER),
  cooper_ore(sprite: Assets.IMAGES_RESOURCES_WOOD),
  bronze(sprite: Assets.IMAGES_RESOURCES_BREAD);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name;
}
