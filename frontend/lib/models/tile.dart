import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/tile_type.dart';
import 'package:gatewayguardians/utils/tile_renderer.dart';

class Tile {
  final int x;
  final int y;
  final TileType tileType;
  final PatchType? patchType;
  final TileRenderer renderer;

  Tile({
    required this.x,
    required this.y,
    required this.tileType,
    required this.patchType,
  }) : renderer = TileRenderer(x: x, y: y);

  bool get hasPatch => patchType != null;

  bool hasPatchType(PatchType type) => patchType == type;
}
