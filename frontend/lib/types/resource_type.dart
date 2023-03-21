import 'package:tensionplanet/utils/assets.dart';

enum ResourceType {
  // energy
  energy(sprite: Assets.IMAGES_RESOURCES_ENERGY),

  // resources
  iron_ore(sprite: Assets.IMAGES_RESOURCES_IRON_ORE),
  copper_ore(sprite: Assets.IMAGES_RESOURCES_COPPER_ORE),
  coal_ore(sprite: Assets.IMAGES_RESOURCES_COAL_ORE),
  oil(sprite: Assets.IMAGES_RESOURCES_OIL),
  stone_ore(sprite: Assets.IMAGES_RESOURCES_STONE_ORE),

  // materials
  iron_block(sprite: Assets.IMAGES_RESOURCES_IRON_BLOCK),
  copper_block(sprite: Assets.IMAGES_RESOURCES_COPPER_BLOCK),
  steel(sprite: Assets.IMAGES_RESOURCES_STEEL),
  plastic(sprite: Assets.IMAGES_RESOURCES_PLASTIC),
  concrete(sprite: Assets.IMAGES_RESOURCES_CONCRETE),

  // components
  gear(sprite: Assets.IMAGES_RESOURCES_GEAR),
  circuit(sprite: Assets.IMAGES_RESOURCES_CIRCUIT),

  // machines
  drone(sprite: Assets.IMAGES_DRONES_BASIC_DRONE),

  // other
  time(sprite: Assets.IMAGES_RESOURCES_TIME);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
