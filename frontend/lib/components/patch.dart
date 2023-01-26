import 'package:tensionnode/components/cell.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch extends Cell {
  final ResourceType resourceType;

  Patch({
    required super.i,
    required super.j,
    required this.resourceType,
  }) : super(path: resourceType.pathMine);
}
