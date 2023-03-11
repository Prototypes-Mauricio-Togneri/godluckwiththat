import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/json.dart';

typedef JsonInventory = Map<ResourceType, int>;

typedef ResourceMap = Map<ResourceType, int>;

class Inventory {
  final ResourceMap _resources;

  Inventory(this._resources);

  List<Resource> get list =>
      _resources.entries.map((e) => Resource(e.key, e.value)).toList();

  bool get isEmpty {
    for (final Resource resource in list) {
      if (resource.amount != 0) {
        return false;
      }
    }

    return true;
  }

  int get(ResourceType type) => _resources[type] ?? 0;

  void addResource(Resource resource) {
    final int current = get(resource.type);
    _resources[resource.type] = current + resource.amount;
  }

  void removeResource(Resource resource) {
    final int current = get(resource.type);
    _resources[resource.type] = current - resource.amount;
  }

  void add(Inventory inventory) {
    for (final Resource resource in inventory.list) {
      addResource(resource);
    }
  }

  void remove(Inventory inventory) {
    for (final Resource resource in inventory.list) {
      removeResource(resource);
    }
  }

  bool hasResourceType(ResourceType type) => _resources[type] != null;

  bool hasResource(Resource resource) => get(resource.type) >= resource.amount;

  JsonInventory get json => _resources;

  factory Inventory.fromJson(JsonInventory map) {
    final ResourceMap resourceMap = {};

    for (final MapEntry<ResourceType, int> entry in map.entries) {
      resourceMap[entry.key] = entry.value;
    }

    return Inventory(resourceMap);
  }

  @override
  String toString() => Json.encode(_resources);
}
