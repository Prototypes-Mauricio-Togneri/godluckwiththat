import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/services/json.dart';
import 'package:tensionnode/types/resource_type.dart';

typedef JsonInventory = Map<ResourceType, int>;

typedef ResourceMap = Map<ResourceType, int>;

class Inventory {
  final ResourceMap _resources;

  Inventory(this._resources);

  List<Resource> get list =>
      _resources.entries.map((e) => Resource(e.key, e.value)).toList();

  List<ResourceType> get types => _resources.keys.toList();

  bool get isEmpty {
    for (final Resource resource in list) {
      if (resource.amount != 0) {
        return false;
      }
    }

    return true;
  }

  int get(ResourceType type) => _resources[type] ?? 0;

  void load(JsonInventory map) {
    for (final MapEntry<ResourceType, int> entry in map.entries) {
      _resources[entry.key] = entry.value;
    }
  }

  void addResource(Resource resource) {
    final int current = get(resource.type);
    _resources[resource.type] = current + resource.amount;
  }

  void removeResource(Resource resource) {
    final int current = get(resource.type);
    _resources[resource.type] = current - resource.amount;
  }

  void remove(Inventory inventory) {
    for (final Resource resource in inventory.list) {
      removeResource(resource);
    }
  }

  // TODO(momo): implement
  bool has(Inventory inventory) => true;

  bool hasResource(Resource resource) => get(resource.type) >= resource.amount;

  JsonInventory get json => _resources;

  @override
  String toString() => Json.encode(_resources);
}
