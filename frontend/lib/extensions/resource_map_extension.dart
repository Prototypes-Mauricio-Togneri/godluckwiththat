import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

typedef ResourceMap = Map<ResourceType, double>;

extension ResourceMapExtension on ResourceMap {
  bool contains(ResourceType resourceType) => keys.contains(resourceType);

  double get(ResourceType resourceType) => this[resourceType] ?? 0;

  double get duration {
    final resourcesAmount =
        resources().map((r) => r.amount).reduce((a, b) => a + b);

    return resourcesAmount / 100;
  }

  ResourceMap multiply(int factor) {
    final ResourceMap result = {};

    for (final Resource resource in resources()) {
      result[resource.resourceType] = resource.amount * factor;
    }

    return result;
  }

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
