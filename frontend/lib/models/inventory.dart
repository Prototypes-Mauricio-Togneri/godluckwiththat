import 'package:tensionnode/services/json.dart';
import 'package:tensionnode/types/resource_type.dart';

typedef JsonInventory = Map<ResourceType, int>;

class Inventory {
  final Map<ResourceType, int> _resources = {};

  Iterable<MapEntry<ResourceType, int>> get entries => _resources.entries;

  bool get isEmpty => _resources.isEmpty;

  void load(Map<ResourceType, int> map) {
    for (final MapEntry<ResourceType, int> entry in map.entries) {
      _resources[entry.key] = entry.value;
    }
  }

  int get(ResourceType type) => _resources[type] ?? 0;

  void addResource({
    required ResourceType type,
    required int amount,
  }) {
    final int current = get(type);
    _resources[type] = current + amount;
  }

  void removeResource({
    required ResourceType type,
    required int amount,
  }) {
    final int current = get(type);
    _resources[type] = current - amount;
  }

  void remove(Inventory inventory) {
    for (final MapEntry<ResourceType, int> entry
        in inventory._resources.entries) {
      removeResource(
        type: entry.key,
        amount: entry.value,
      );
    }
  }

  // TODO(momo): implement
  bool has(Inventory inventory) => true;

  JsonInventory get json => _resources;

  @override
  String toString() => Json.encode(_resources);
}
