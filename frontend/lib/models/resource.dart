import 'package:tensionplanet/types/resource_type.dart';

class Resource {
  final ResourceType resourceType;
  final int amount;

  const Resource(this.resourceType, this.amount);

  factory Resource.one(ResourceType resourceType) => Resource(resourceType, 1);
}
