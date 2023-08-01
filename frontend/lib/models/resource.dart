import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Resource {
  final ResourceType resourceType;
  final int amount;

  const Resource(this.resourceType, this.amount);

  ResourceMap get map => {resourceType: amount};

  factory Resource.one(ResourceType resourceType) => Resource(resourceType, 1);

  factory Resource.villager(int amount) =>
      Resource(ResourceType.villager, amount);

  factory Resource.food(int amount) => Resource(ResourceType.food, amount);

  factory Resource.wood(int amount) => Resource(ResourceType.wood, amount);

  factory Resource.stone(int amount) => Resource(ResourceType.stone, amount);

  factory Resource.copper(int amount) => Resource(ResourceType.copper, amount);

  factory Resource.iron(int amount) => Resource(ResourceType.iron, amount);

  factory Resource.gold(int amount) => Resource(ResourceType.gold, amount);

  @override
  String toString() => '$resourceType: $amount';
}
