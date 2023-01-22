import 'package:dafluta/dafluta.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/dialog/main_menu.dart';
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
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/node_type.dart';

class MyGame extends Zoomable with HasTappables, KeyboardEvents {
  final GameState state;

  MyGame(this.state);

  @override
  Future onLoad() async {
    add(Background(camera));
    add(FpsTextComponent(
      position: Vector2(
        10,
        size.y - 40,
      ),
      textRenderer: Style.textRenderer(size: 20),
    ));
    add(Hud(
      xPosition: size.x / 2,
      state: state,
    ));

    final JsonMatch jsonMatch = await Loader.match(Assets.MAPS_MAP1);
    state.load(jsonMatch);

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

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final bool isKeyDown = event is RawKeyDownEvent;
    final bool isSpace = keysPressed.contains(LogicalKeyboardKey.escape);

    if (isSpace && isKeyDown) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => Delayed.post(() => MainMenu.show(game: this)),
      );

      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }
}
