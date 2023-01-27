import 'package:tensionnode/components/static_element.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch extends StaticElement {
  final ResourceType resourceType;

  Patch({
    required super.i,
    required super.j,
    required this.resourceType,
  }) : super(path: resourceType.pathPatch);
}
