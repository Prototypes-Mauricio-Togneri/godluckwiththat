import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch extends Node {
  final ResourceType resourceType;

  Patch({
    required super.i,
    required super.j,
    required this.resourceType,
  }) : super(path: resourceType.pathMine);
}
