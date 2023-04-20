import 'package:flutter/widgets.dart';
import 'package:tensionplanet/components/building_sprite.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/building_type.dart';

class Building {
  final Village village;
  final BuildingType buildingType;
  final Offset offset;
  int level;

  Building({
    required this.village,
    required this.buildingType,
    required this.offset,
    required this.level,
  });

  void update(double dt) {}

  BuildingSprite get sprite => BuildingSprite(this);
}
