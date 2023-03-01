import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/services/json.dart';
import 'package:tensionnode/types/resource_type.dart';

typedef JsonInventory = Map<ResourceType, int>;

typedef ResourceMap = Map<ResourceType, int>;

class Inventory {
  final ResourceMap _resources = {};

  List<Resource> get list => _resources.entries.map((e) => Resource(e.key, e.value)).toList();

  bool get isEmpty => _resources.isEmpty;

  int get(ResourceType type) => _resources[type] ?? 0;

  void load(JsonInventory map) {
    for (final MapEntry<ResourceType, int> entry in map.entries) {
      _resources[entry.key] = entry.value;
    }
  }

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
