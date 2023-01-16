import 'package:flame/components.dart';
import 'package:tensionnode/engine/cell.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch extends Cell with Tappable {
  final ResourceType resourceType;

  Patch({
    required super.i,
    required super.j,
    required super.path,
    required this.resourceType,
  });
}
