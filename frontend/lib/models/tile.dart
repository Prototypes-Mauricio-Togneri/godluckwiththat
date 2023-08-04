import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/tile_type.dart';

class Tile {
  final int x;
  final int y;
  final TileType tileType;
  final PatchType? patchType;
  Building? building;

  Tile({
    required this.x,
    required this.y,
    required this.tileType,
    required this.patchType,
    required this.building,
  });

  bool get hasPatch => patchType != null;

  bool hasPatchType(PatchType type) => patchType == type;
}
