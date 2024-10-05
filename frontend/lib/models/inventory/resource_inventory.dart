import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/inventory/base_inventory.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class ResourceInventory extends BaseInventory<ResourceType> {
  ResourceInventory._(super.stockpile);

  factory ResourceInventory.empty() => ResourceInventory._({});

  factory ResourceInventory.create(ResourceMap resources) =>
      ResourceInventory._(resources);
}
