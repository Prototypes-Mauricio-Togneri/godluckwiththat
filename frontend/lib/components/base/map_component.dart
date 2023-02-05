import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/models/map_tile.dart';

class MapComponent extends TiledComponent {
  late int mapWidth;
  late int mapHeight;

  MapComponent(super.tileMap) {
    mapWidth = tileMap.map.width;
    mapHeight = tileMap.map.height;
    final double offsetX =
        -((mapWidth / 2) * Constants.NODE_SIZE) + (Constants.NODE_SIZE / 2);
    final double offsetY =
        -((mapHeight / 2) * Constants.NODE_SIZE) + (Constants.NODE_SIZE / 2);
    position = Vector2(offsetX, offsetY);
  }

  MapTile tile({
    required int i,
    required int j,
  }) {
    final Gid? gid = tileMap.getTileData(
      layerId: 0,
      x: i + (mapWidth ~/ 2) - 1,
      y: j + (mapHeight ~/ 2) - 1,
    );

    return MapTile((gid != null) ? gid.tile : 0);
  }

  static Future<MapComponent> load(String contents) async {
    return MapComponent(
      await RenderableTiledMap.fromString(
        contents,
        Vector2.all(Constants.NODE_SIZE),
      ),
    );
  }
}
