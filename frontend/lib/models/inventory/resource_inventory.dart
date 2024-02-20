import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/inventory/base_inventory.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class ResourceInventory extends BaseInventory<ResourceType> {
  ResourceInventory._(super.stockpile, super.capacities);

  factory ResourceInventory.empty() => ResourceInventory._({}, {});

  factory ResourceInventory.create({
    required ResourceMap resources,
    required ResourceMap capacities,
  }) {
    final ResourceMap resourceMap = {};
    final ResourceMap capacitiesMap = {};

    for (final ResourceMapEntry resource in resources.entries) {
      resourceMap[resource.key] = resource.value;
      capacitiesMap[resource.key] = capacities[resource.key] ?? 0;
    }

    return ResourceInventory._(resourceMap, capacitiesMap);
  }
}
