import 'package:tensionnode/components/base/map_element.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch extends MapElement {
  final ResourceType resourceType;

  Patch({
    required super.i,
    required super.j,
    required this.resourceType,
  }) : super(image: resourceType.image);
}
