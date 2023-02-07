import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(color: Palette.resourceRed),
  green(color: Palette.resourceGreen),
  blue(color: Palette.resourceBlue);

  final Color color;

  const ResourceType({
    required this.color,
  });
}
