import 'package:godluckwiththat/extensions/item_map_extension.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

typedef ResourceMap = ItemMap<ResourceType>;

extension ResourceMapExtension on ResourceMap {
  double get duration {
    final resourcesAmount = list.map((r) => r.amount).reduce((a, b) => a + b);

    return resourcesAmount / 100;
  }

  ResourceMap multiply(int factor) {
    final ResourceMap result = {};

    for (final Resource resource in list) {
      result[resource.resourceType] = resource.amount * factor;
    }

    return result;
  }

  List<Resource> get list {
    final List<Resource> result = [];

    for (final ResourceType resourceType in keys) {
      result.add(Resource(resourceType, get(resourceType)));
    }

    return result;
  }
}
