import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(Palette.resource_red),
  green(Palette.resource_green),
  blue(Palette.resource_blue);

  final Color color;

  const ResourceType(this.color);
}
