import 'package:tensionnode/json/json_inventory.dart';
import 'package:tensionnode/services/json.dart';
import 'package:tensionnode/types/resource_type.dart';

class Inventory {
  final Map<ResourceType, int> _resources = {};

  Inventory() {
    for (final ResourceType resource in ResourceType.values) {
      _resources[resource] = 0;
    }
  }

  factory Inventory.fromList({
    required int coalOre,
    required int cooperOre,
    required int bronze,
  }) {
    final Inventory inventory = Inventory();

    inventory._resources[ResourceType.coal_ore] = coalOre;
    inventory._resources[ResourceType.cooper_ore] = cooperOre;
    inventory._resources[ResourceType.bronze] = bronze;

    return inventory;
  }

  bool get isEmpty => _resources.isEmpty;

  void set(Map<ResourceType, int> resources) {
    for (final MapEntry<ResourceType, int> entry in resources.entries) {
      final int current = _resources[entry.key] ?? 0;
      _resources[entry.key] = current + entry.value;
    }
  }

  void add(ResourceType type) {
    final int current = _resources[type] ?? 0;
    _resources[type] = current + 1;
  }

  void remove(Inventory inventory) {
    for (final MapEntry<ResourceType, int> entry
        in inventory._resources.entries) {
      final int current = _resources[entry.key] ?? 0;
      _resources[entry.key] = current - entry.value;
    }
  }

  // TODO(momo): implement
  bool has(Inventory inventory) => true;

  JsonInventory get json => JsonInventory(
        coalOre: _resources[ResourceType.coal_ore] ?? 0,
        cooperOre: _resources[ResourceType.cooper_ore] ?? 0,
        bronze: _resources[ResourceType.bronze] ?? 0,
      );

  @override
  String toString() => Json.encode(json.toJson());
}
