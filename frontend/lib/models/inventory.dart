import 'dart:math';
import 'package:godluckwiththat/extensions/item_map_extension.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Inventory {
  final ResourceMap _resources;
  final ResourceMap _capacities;

  Inventory._(this._resources, this._capacities);

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

  double capacityOf(ResourceType resourceType) =>
      _capacities.get(resourceType);

  double get(ResourceType resourceType) => _resources.get(resourceType);

  Resource resource(ResourceType resourceType) =>
      Resource(resourceType, get(resourceType));

  void addResource(Resource resource) {
    final double current = get(resource.resourceType);
    final double capacity = capacityOf(resource.resourceType);
    _resources[resource.resourceType] =
        min(current + resource.amount, capacity);
  }

  void removeResource(Resource resource) {
    final double current = get(resource.resourceType);
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

  void addMapResources(ResourceMap resources) =>
      addResources(resources.resources());

  void removeMapResources(ResourceMap resources) =>
      removeResources(resources.resources());

  void addInventory(Inventory inventory) => addResources(inventory.list);

  void removeInventory(Inventory inventory) => removeResources(inventory.list);

  bool hasResourceType(ResourceType resourceType) =>
      _resources[resourceType] != null;

  bool hasResource(Resource resource) =>
      get(resource.resourceType) >= resource.amount;

  bool hasResources(List<Resource> resources) {
    for (final Resource resource in resources) {
      if (!hasResource(resource)) {
        return false;
      }
    }

    return true;
  }

  bool hasMapResources(ResourceMap resources) =>
      hasResources(resources.resources());

  factory Inventory.empty() => Inventory._({}, {});

  factory Inventory.create({
    required ResourceMap resources,
    required ResourceMap capacities,
  }) {
    final ResourceMap resourceMap = {};
    final ResourceMap capacitiesMap = {};

    for (final Resource resource in resources.resources()) {
      resourceMap[resource.resourceType] = resource.amount;
      capacitiesMap[resource.resourceType] =
          capacities[resource.resourceType] ?? 0;
    }

    return Inventory._(resourceMap, capacitiesMap);
  }
}
