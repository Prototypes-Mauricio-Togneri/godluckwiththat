import 'package:tensionnode/types/resource_type.dart';

class Resource {
  final ResourceType type;
  final int amount;

  const Resource(this.type, this.amount);

  factory Resource.one(ResourceType type) => Resource(type, 1);
}
