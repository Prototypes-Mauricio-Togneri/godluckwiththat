import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';

typedef ResourceMap = Map<ResourceType, int>;

extension ResourceMapExtension on ResourceMap {
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
