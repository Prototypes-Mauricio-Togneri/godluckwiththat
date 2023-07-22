import 'package:flutter/material.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';
import 'package:gatewayguardians/types/zone_type.dart';

class Zone {
  final int x;
  final int y;
  final ZoneType zoneType;
  final List<PatchType> patches;
  String? owner;
  Building? building;
  ZoneStatus status;

  Zone({
    required this.x,
    required this.y,
    required this.zoneType,
    required this.patches,
    required this.owner,
    required this.building,
    required this.status,
  });

  String get id => '$x,$y';

  bool get isOwned => owner == Constants.PLAYER_OWNER;

  bool get isNeutral => owner == null;

  Color get color {
    switch (zoneType) {
      case ZoneType.grass:
        return Colors.green;
      case ZoneType.desert:
        return Colors.orange;
      case ZoneType.snow:
        return Colors.white;
      case ZoneType.mountain:
        return Colors.brown;
      case ZoneType.water:
        return Colors.blue;
    }
  }

  ResourceMap explorationCost() => {
        ResourceType.food: 100,
      };

  ResourceMap conquerCost() => {
        ResourceType.food: 100,
      };

  JsonZone get json => JsonZone(
        id: id,
        x: x.toDouble(),
        y: y.toDouble(),
        owner: owner ?? '',
        status: status,
        patches: [],
      );
}
