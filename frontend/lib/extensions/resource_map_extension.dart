import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/types/resource_type.dart';

typedef ResourceMap = Map<ResourceType, int>;

extension ResourceMapExtension on ResourceMap {
  Inventory get asInventory => Inventory.fromResourceMap(this);

  bool contains(ResourceType resourceType) => keys.contains(resourceType);

  int get(ResourceType resourceType) => this[resourceType] ?? 0;

  List<Resource> resources() {
    final List<Resource> result = [];

    for (final ResourceType resourceType in keys) {
      result.add(Resource(resourceType, get(resourceType)));
    }

    return result;
  }
}
