import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';
import 'package:gatewayguardians/types/zone_type.dart';

class Zone {
  final String id;
  final double x;
  final double y;
  final ZoneType zoneType;
  final List<PatchType> patches;
  String? owner;
  ZoneStatus status;

  Zone({
    required this.id,
    required this.x,
    required this.y,
    required this.zoneType,
    required this.patches,
    required this.owner,
    required this.status,
  });

  int get i => int.parse(id.split(',')[0]);

  int get j => int.parse(id.split(',')[1]);

  bool get isOwned => owner == Constants.PLAYER_OWNER;

  bool get isNeutral => owner == null;

  ResourceMap explorationCost() => {
        ResourceType.food: 100,
      };

  ResourceMap conquerCost() => {
        ResourceType.food: 100,
      };

  JsonZone get json => JsonZone(
        id: id,
        x: x,
        y: y,
        owner: owner ?? '',
        status: status,
        patches: [],
      );
}
