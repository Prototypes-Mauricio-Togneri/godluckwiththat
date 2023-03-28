import 'package:tensionplanet/extensions/resource_map_extension.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/utils/assets.dart';

enum ResourceType {
  // energy
  energy(sprite: Assets.IMAGES_RESOURCES_ENERGY_ENERGY),

  // resources
  iron_ore(sprite: Assets.IMAGES_RESOURCES_RESOURCES_IRON_ORE),
  copper_ore(sprite: Assets.IMAGES_RESOURCES_RESOURCES_COPPER_ORE),
  stone_ore(sprite: Assets.IMAGES_RESOURCES_RESOURCES_STONE_ORE),
  water(sprite: Assets.IMAGES_RESOURCES_RESOURCES_WATER),
  coal_ore(sprite: Assets.IMAGES_RESOURCES_RESOURCES_COAL_ORE),
  crude_oil(sprite: Assets.IMAGES_RESOURCES_RESOURCES_OIL),
  titanium_ore(sprite: Assets.IMAGES_RESOURCES_RESOURCES_TITANIUM_ORE),
  uranium_ore(sprite: Assets.IMAGES_RESOURCES_RESOURCES_URANIUM_ORE),

  // materials
  iron_plate(sprite: Assets.IMAGES_RESOURCES_MATERIALS_IRON_PLATE),
  copper_plate(sprite: Assets.IMAGES_RESOURCES_MATERIALS_COPPER_PLATE),
  concrete(sprite: Assets.IMAGES_RESOURCES_MATERIALS_CONCRETE),
  steel(sprite: Assets.IMAGES_RESOURCES_MATERIALS_STEEL),
  plastic(sprite: Assets.IMAGES_RESOURCES_MATERIALS_PLASTIC),
  sulfur(sprite: Assets.IMAGES_RESOURCES_MATERIALS_SULFUR),
  fuel(sprite: Assets.IMAGES_RESOURCES_MATERIALS_FUEL),
  titanium_plate(sprite: Assets.IMAGES_RESOURCES_MATERIALS_TITANIUM_PLATE),

  // components
  gear(sprite: Assets.IMAGES_RESOURCES_GEAR),
  wire(sprite: Assets.IMAGES_RESOURCES_WIRE),
  circuit(sprite: Assets.IMAGES_RESOURCES_CIRCUIT),
  motor(sprite: Assets.IMAGES_RESOURCES_MOTOR),
  battery(sprite: Assets.IMAGES_RESOURCES_BATTERY),
  carbon_fiber(sprite: Assets.IMAGES_RESOURCES_CARBON_FIBER),

  // machines
  drone(sprite: Assets.IMAGES_RESOURCES_DRONE),
  explorer(sprite: Assets.IMAGES_RESOURCES_EXPLORER),
  rocket(sprite: Assets.IMAGES_RESOURCES_ROCKET),

  // other
  time(sprite: Assets.IMAGES_RESOURCES_TIME);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  static List<ResourceType> usedFor(ResourceType resourceType) {
    final List<ResourceType> result = [];

    for (final NodeType nodeType in NodeType.values) {
      if (nodeType.input.contains(resourceType)) {
        for (final ResourceType resourceType in nodeType.output.keys) {
          result.add(resourceType);
        }
      }
    }

    return result;
  }

  static NodeType producedIn(ResourceType resourceType) {
    for (final NodeType nodeType in NodeType.values) {
      if (nodeType.output.contains(resourceType)) {
        return nodeType;
      }
    }

    throw Exception('Resource not produced anywhere');
  }

  @override
  String toString() => name.replaceAll('_', ' ');
}
