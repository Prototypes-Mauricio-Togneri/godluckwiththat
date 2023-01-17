import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/game_state.dart';
import 'package:tensionnode/engine/headquarters.dart';
import 'package:tensionnode/engine/hud.dart';
import 'package:tensionnode/engine/loader.dart';
import 'package:tensionnode/engine/mine.dart';
import 'package:tensionnode/engine/patch.dart';
import 'package:tensionnode/engine/zoomable.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/node_type.dart';

class MyGame extends Zoomable with HasTappables {
  final GameState gameState = GameState();

  @override
  Future onLoad() async {
    add(FpsTextComponent(position: Vector2(10, 10)));
    add(Hud(
      xPosition: size.x / 2,
      gameState: gameState,
    ));

    final JsonMatch jsonMatch = await Loader.match(Assets.MAPS_MAP1);
    gameState.red = jsonMatch.resources.red;
    gameState.green = jsonMatch.resources.green;
    gameState.blue = jsonMatch.resources.blue;

    for (final JsonPatch patch in jsonMatch.patches) {
      add(Patch(
        i: patch.position.x,
        j: patch.position.y,
        resourceType: patch.resource,
      ));
    }

    for (final JsonNode node in jsonMatch.nodes) {
      if (node.type == NodeType.mine) {
        add(Mine(
          i: node.position.x,
          j: node.position.y,
          resourceType: node.resource!,
          gameState: gameState,
        ));
      } else if (node.type == NodeType.headquarters) {
        add(Headquarters(
          i: node.position.x,
          j: node.position.y,
        ));
      }
    }

    return super.onLoad();
  }

  @override
  Color backgroundColor() => const Color(0xff1a1a1a);

  @override
  void render(Canvas canvas) {
    final Rect viewport = Rect.fromCenter(
      center: const Offset(0, 0),
      width: camera.viewport.canvasSize!.x,
      height: camera.viewport.canvasSize!.y,
    );
    //final double zoom = camera.zoom;

    //if (zoom >= 3) {
    for (int i = 1; i < 100; i++) {
      final double x = (i * Constants.CELL_SIZE).toDouble();

      if ((x >= viewport.left) && (x <= viewport.right)) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.y),
          Palette.gridPaint,
        );
      }
    }

    for (int i = 1; i < 100; i++) {
      final double y = (i * Constants.CELL_SIZE).toDouble();

      if ((y >= viewport.top) && (y <= viewport.bottom)) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.x, y),
          Palette.gridPaint,
        );
      }
    }
    //}

    return super.render(canvas);
  }

  void save() {
    /*final JsonMatch jsonMatch = JsonMatch(
      version: match.version,
      id: match.id,
      map: map.json,
      resources: headquarters.jsonResources,
      patches: patches.json,
      nodes: nodes.json,
    );

    ClipboardText().copy(jsonMatch.toJsonString());*/
  }
}
