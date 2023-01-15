import 'package:flutter/widgets.dart';
import 'package:tensionnode/extensions/offset_extension.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/types/resource_type.dart';

class Patch {
  final ResourceType type;
  final Offset position;

  const Patch({
    required this.type,
    required this.position,
  });

  bool isAt(Offset testPosition) => position == testPosition;

  JsonPatch get json => JsonPatch(
        resource: type,
        position: position.json,
      );
}
