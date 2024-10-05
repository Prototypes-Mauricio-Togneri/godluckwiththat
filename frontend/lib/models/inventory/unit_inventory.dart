import 'package:godluckwiththat/extensions/unit_map_extension.dart';
import 'package:godluckwiththat/models/inventory/base_inventory.dart';
import 'package:godluckwiththat/types/unit_type.dart';

class UnitInventory extends BaseInventory<UnitType> {
  UnitInventory._(super.stockpile);

  factory UnitInventory.empty() => UnitInventory._({});

  factory UnitInventory.create(UnitMap units) => UnitInventory._(units);
}
