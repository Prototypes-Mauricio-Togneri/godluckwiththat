import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:tensionnode/engine/background.dart';
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
import 'package:tensionnode/types/node_type.dart';

class MyGame extends Zoomable with HasTappables {
  final GameState state;

  MyGame(this.state);

  @override
  Future onLoad() async {
    add(FpsTextComponent(
      position: Vector2(
        10,
        size.y - 40,
      ),
    ));
    add(Background(camera));
    add(Hud(
      xPosition: size.x / 2,
      state: state,
    ));

    final JsonMatch jsonMatch = await Loader.match(Assets.MAPS_MAP1);
    state.red = jsonMatch.resources.red;
    state.green = jsonMatch.resources.green;
    state.blue = jsonMatch.resources.blue;

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
