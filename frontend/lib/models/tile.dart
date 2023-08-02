import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/tile_type.dart';

class Tile {
  final int x;
  final int y;
  final TileType tileType;
  final PatchType? patchType;

  Tile({
    required this.x,
    required this.y,
    required this.tileType,
    required this.patchType,
  });

  bool get hasPatch => patchType != null;

  bool hasPatchType(PatchType type) => patchType == type;
}
