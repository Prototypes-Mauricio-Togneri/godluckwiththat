import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

typedef ItemMap<T> = Map<T, double>;

extension ItemMapExtension<T> on ItemMap<T> {
  bool contains(T type) => keys.contains(type);

  double get(T type) => this[type] ?? 0;

  String join() {
    String result = '';

    for (final T type in keys) {
      if (result.isNotEmpty) {
        result += '\n';
      }

      result += '$type: ${get(type)}';
    }

    return result;
  }
}

typedef ResourceMap = ItemMap<ResourceType>;

extension ResourceMapExtension on ResourceMap {
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

  List<Resource> resources() {
    final List<Resource> result = [];

    for (final ResourceType resourceType in keys) {
      result.add(Resource(resourceType, get(resourceType)));
    }

    return result;
  }
}
