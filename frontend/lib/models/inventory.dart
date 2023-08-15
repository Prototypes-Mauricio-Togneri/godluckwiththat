import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/json.dart';

typedef JsonInventory = Map<ResourceType, int>;

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

  int get(ResourceType resourceType) => _resources.get(resourceType);

  Resource resource(ResourceType resourceType) =>
      Resource(resourceType, get(resourceType));

  void addResource(Resource resource) {
    final int current = get(resource.resourceType);
    _resources[resource.resourceType] = current + resource.amount;
  }

  void removeResource(Resource resource) {
    final int current = get(resource.resourceType);
    _resources[resource.resourceType] = current - resource.amount;
  }

  void addResources(List<Resource> resources) {
    for (final Resource resource in resources) {
      addResource(resource);
    }
  }

  void removeResources(List<Resource> resources) {
    for (final Resource resource in resources) {
      removeResource(resource);
    }
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

  bool hasResources(ResourceMap map) {
    for (final Resource resource in map.resources()) {
      if (!hasResource(resource)) {
        return false;
      }
    }

    return true;
  }

  JsonInventory get json => _resources;

  factory Inventory.empty() => Inventory._({});

  factory Inventory.fromResourceMap(ResourceMap map) {
    final ResourceMap resourceMap = {};

    for (final Resource resource in map.resources()) {
      resourceMap[resource.resourceType] = resource.amount;
    }

    return Inventory._(resourceMap);
  }

  factory Inventory.fromJson(JsonInventory map) {
    final ResourceMap resourceMap = {};

    for (final Resource resource in map.resources()) {
      resourceMap[resource.resourceType] = resource.amount;
    }

    return Inventory._(resourceMap);
  }

  @override
  String toString() => Json.encode(_resources);
}
