import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/components/background.dart';
import 'package:tensionnode/components/headquarters.dart';
import 'package:tensionnode/components/mine.dart';
import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/components/patch.dart';
import 'package:tensionnode/components/resource.dart';
import 'package:tensionnode/components/resources_hud.dart';
import 'package:tensionnode/dialog/build_menu.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/dialog/mine_menu.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/loader.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/node_type.dart';

class GameComponent extends BaseGameComponent {
  final GameState state;

  GameComponent(this.state);

  @override
  Future onLoad() async {
    final JsonMatch jsonMatch = await Loader.match(Assets.MAPS_MAP1);
    state.load(jsonMatch);

    add(Background(camera));
    add(FpsTextComponent(
      position: Vector2(
        10,
        size.y - 40,
      ),
      textRenderer: Style.textRenderer(size: 20),
    ));
    add(ResourcesHud());

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

  void removeNode(Node node) {
    remove(node);
  }

  @override
  void onKeyPressed(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) {
      openMenu(
        name: MainMenu.NAME,
        pauseGame: true,
      );
    } else if (key == LogicalKeyboardKey.space) {
      _createTestObjects();
    }
  }

  void _createTestObjects() {
    for (int i = -15; i < 15; i++) {
      for (int j = -15; j < 15; j++) {
        add(Resource(
          i: i,
          j: j,
          path: Assets.IMAGES_PATCH_RED,
        ));
      }
    }
  }

  void removeComponents(Type type) => removeWhere((c) {
        c.removeWhere((c) => c.runtimeType == type);

        return c.runtimeType == type;
      });

  void openMainMenu() => openMenu(
        name: MainMenu.NAME,
        pauseGame: true,
      );

  void openBuildMenu() => openMenu(name: BuildMenu.NAME);

  void openMenu({
    required String name,
    bool pauseGame = false,
    dynamic node,
  }) {
    if (node != null) {
      state.selectedNode = node;
    }

    if (!overlays.isActive(name)) {
      if (pauseGame) {
        pauseEngine();
      }
      overlays.add(name);
    }
  }

  void closeMenu({
    required String name,
    bool resumeGame = false,
  }) {
    if (overlays.isActive(name)) {
      overlays.remove(name);

      if (resumeGame) {
        resumeEngine();
      }
    }
  }

  @override
  void onMapInteraction() {
    closeMenu(name: MineMenu.NAME);
    closeMenu(name: BuildMenu.NAME);
  }
}
