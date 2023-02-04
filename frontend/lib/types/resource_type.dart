import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(color: Palette.resource_red),
  green(color: Palette.resource_green),
  blue(color: Palette.resource_blue);

  final Color color;

  const ResourceType({
    required this.color,
  });
}
