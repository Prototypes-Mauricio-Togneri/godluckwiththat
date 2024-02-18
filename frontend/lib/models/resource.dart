import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Resource {
  final ResourceType resourceType;
  final double amount;

  const Resource(this.resourceType, this.amount);

  ResourceMap get map => {resourceType: amount};

  factory Resource.one(ResourceType resourceType) => Resource(resourceType, 1);

  factory Resource.villager(int amount) =>
      Resource(ResourceType.villager, amount.toDouble());

  factory Resource.water(double amount) => Resource(ResourceType.water, amount);

  factory Resource.food(double amount) => Resource(ResourceType.food, amount);

  factory Resource.wood(double amount) => Resource(ResourceType.wood, amount);

  factory Resource.stone(double amount) => Resource(ResourceType.stone, amount);

  @override
  String toString() => '$resourceType: $amount';
}
