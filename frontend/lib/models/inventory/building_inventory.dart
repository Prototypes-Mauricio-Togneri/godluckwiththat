import 'package:godluckwiththat/extensions/building_map_extension.dart';
import 'package:godluckwiththat/models/inventory/base_inventory.dart';
import 'package:godluckwiththat/types/building_type.dart';

class BuildingInventory extends BaseInventory<BuildingType> {
  BuildingInventory._(super.stockpile);

  factory BuildingInventory.empty() => BuildingInventory._({});

  factory BuildingInventory.create(BuildingMap buildings) =>
      BuildingInventory._(buildings);
}
