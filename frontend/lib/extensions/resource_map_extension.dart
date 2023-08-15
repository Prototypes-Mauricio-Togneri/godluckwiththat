import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

typedef ResourceMap = Map<ResourceType, int>;

extension ResourceMapExtension on ResourceMap {
  Inventory get asInventory => Inventory.fromResourceMap(this);

  bool contains(ResourceType resourceType) => keys.contains(resourceType);

  int get(ResourceType resourceType) => this[resourceType] ?? 0;

  String join() {
    String result = '';

    for (final ResourceType resourceType in keys) {
      if (result.isNotEmpty) {
        result += '\n';
      }

      result += '$resourceType: ${get(resourceType)}';
    }

    return result;
  }

  List<Resource> resources() {
    final List<Resource> result = [];

    for (final ResourceType resourceType in keys) {
      result.add(Resource(resourceType, get(resourceType)));
    }

    return result;
  }
}
