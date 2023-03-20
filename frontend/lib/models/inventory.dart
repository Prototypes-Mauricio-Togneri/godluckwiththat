import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/json.dart';

typedef JsonInventory = Map<ResourceType, int>;

typedef ResourceMap = Map<ResourceType, int>;

class Inventory {
  final ResourceMap _resources;

  Inventory._(this._resources);

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

  ResourceMap get resourceMap => _resources;

  int get(ResourceType resourceType) => _resources[resourceType] ?? 0;

  void addResource(Resource resource) {
    final int current = get(resource.resourceType);
    _resources[resource.resourceType] = current + resource.amount;
  }

  void removeResource(Resource resource) {
    final int current = get(resource.resourceType);
    _resources[resource.resourceType] = current - resource.amount;
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

  bool hasResourceType(ResourceType resourceType) =>
      _resources[resourceType] != null;

  bool hasResource(Resource resource) =>
      get(resource.resourceType) >= resource.amount;

  Inventory get half {
    final ResourceMap map = {};

    for (final Resource resource in list) {
      map[resource.resourceType] = resource.amount ~/ 2;
    }

    return Inventory._(map);
  }

  JsonInventory get json => _resources;

  factory Inventory.empty() => Inventory._({});

  factory Inventory.fromResourceMap(ResourceMap map) => Inventory._(map);

  factory Inventory.fromJson(JsonInventory map) {
    final ResourceMap resourceMap = {};

    for (final MapEntry<ResourceType, int> entry in map.entries) {
      resourceMap[entry.key] = entry.value;
    }

    return Inventory._(resourceMap);
  }

  factory Inventory.fromNodeType(NodeType nodeType) {
    final ResourceMap resourceMap = {};

    for (final MapEntry<ResourceType, int> entry in nodeType.input.entries) {
      resourceMap[entry.key] = 0;
    }

    for (final MapEntry<ResourceType, int> entry in nodeType.output.entries) {
      resourceMap[entry.key] = 0;
    }

    return Inventory._(resourceMap);
  }

  @override
  String toString() => Json.encode(_resources);
}
