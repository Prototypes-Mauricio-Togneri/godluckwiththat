import 'package:godluckwiththat/extensions/item_map_extension.dart';
import 'package:godluckwiththat/types/resource_type.dart';

typedef ResourceMap = ItemMap<ResourceType>;

typedef ResourceMapEntry = MapEntry<ResourceType, num>;

extension ResourceMapExtension on ResourceMap {
  num get duration {
    num sum = 0;

    for (final ResourceMapEntry item in entries) {
      sum += item.value;
    }

    return sum / 100;
  }

  ResourceMap multiply(int factor) {
    final ResourceMap result = {};

    for (final ResourceMapEntry item in entries) {
      result[item.key] = item.value * factor;
    }

    return result;
  }
}
