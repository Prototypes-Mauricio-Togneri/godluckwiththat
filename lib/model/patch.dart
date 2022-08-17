import 'package:flutter/widgets.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch {
  final ResourceType type;
  final Offset position;

  const Patch({
    required this.type,
    required this.position,
  });

  bool isAt(Offset testPosition) => position == testPosition;
}
