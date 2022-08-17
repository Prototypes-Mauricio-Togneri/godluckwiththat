import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  resource1(Palette.resource1),
  resource2(Palette.resource2),
  resource3(Palette.resource3);

  final Color color;

  const ResourceType(this.color);
}
