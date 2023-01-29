import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/background.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/resources_hud.dart';
import 'package:tensionnode/components/base/static_element.dart';
import 'package:tensionnode/components/game/bullet.dart';
import 'package:tensionnode/components/game/enemy.dart';
import 'package:tensionnode/components/game/headquarters.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/patch.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/dialog/contextual/build_menu.dart';
import 'package:tensionnode/dialog/contextual/mine_menu.dart';
import 'package:tensionnode/dialog/global/main_menu.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/models/position.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/loader.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/direction.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/types/turret_type.dart';

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
      if (node.type.isMine) {
        addMine(
          i: node.position.x,
          j: node.position.y,
          type: node.type.resource!,
        );
      } else if (node.type.isTurret) {
        addTurret(
          i: node.position.x,
          j: node.position.y,
          type: node.type.turret!,
        );
      } else if (node.type.isHeadquarters) {
        add(Headquarters(
          i: node.position.x,
          j: node.position.y,
        ));
      }
    }

    return super.onLoad();
  }

  void addMine({
    required int i,
    required int j,
    required ResourceType type,
  }) {
    add(Mine(
      i: i,
      j: j,
      type: type,
    ));
  }

  void addTurret({
    required int i,
    required int j,
    required TurretType type,
  }) {
    add(Turret(
      i: i,
      j: j,
      type: type,
    ));
  }

  void addEnemy({
    required int i,
    required int j,
  }) {
    add(Enemy(
      position: Position.fromGrid(i, j),
      direction: Direction.right,
      speed: 50,
      range: 50,
      damage: 30,
    ));
  }

  void addBullet({
    required Vector2 position,
    required Vector2 direction,
    required double range,
    required double damage,
  }) {
    add(Bullet(
      originalPosition: position,
      direction: direction,
      speed: Constants.BULLET_SPEED,
      range: range,
      damage: damage,
    ));
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
      //_createTestObjects();
      _spawnEnemy();
    }
  }

  void _spawnEnemy() {
    addEnemy(
      i: -15,
      j: 7,
    );
  }

  /*void _createTestObjects() {
    for (int i = -15; i < 15; i++) {
      for (int j = -15; j < 15; j++) {
        add(Enemy(
          i: i,
          j: j,
          direction: Direction.right,
          speed: 50,
        ));
      }
    }
  }*/

  @override
  void onMapMoved() {
    _closeContextualMenus();
  }

  void _closeContextualMenus() {
    closeMenu(name: MineMenu.NAME);
    closeMenu(name: BuildMenu.NAME);
  }

  void openMainMenu() => openMenu(
        name: MainMenu.NAME,
        pauseGame: true,
      );

  void openBuildMenu() => openMenu(name: BuildMenu.NAME);

  void openMenu({
    required String name,
    bool pauseGame = false,
    Node? node,
  }) {
    if (node != null) {
      state.selectNode(node);
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

  void enableBuildMode(NodeType type) {
    _disableBuildMode();
    _closeContextualMenus();

    // TODO(momo): don't add it for mobile
    removeComponents(BuildingIndicator);
    add(BuildingIndicator(type: type));

    state.enableBuildMode();
  }

  void _disableBuildMode() {
    _closeContextualMenus();
    removeComponents(BuildingIndicator);
    state.disableBuildMode();
  }

  void enableDeleteMode() {
    _disableDeleteMode();
    _closeContextualMenus();
    state.enableDeleteMode();
  }

  void _disableDeleteMode() {
    _closeContextualMenus();
    state.disableDeleteMode();
  }

  void onCancelOperation() {
    if (state.buildMode) {
      _disableBuildMode();
    } else if (state.deleteMode) {
      _disableDeleteMode();
    }
  }

  @override
  void onMapClicked(Vector2 position) {
    _closeContextualMenus();

    if (hasComponent(BuildingIndicator)) {
      final BuildingIndicator buildingIndicator =
          getComponent(BuildingIndicator);
      final int i = position.x.toInt();
      final int j = position.y.toInt();
      final Node? node = getFixedNode(i, j);
      final StaticElement? staticElement = getStaticElement(i, j);
      final NodeType nodeType = buildingIndicator.type;

      if ((node == null) && state.resources.has(nodeType.cost)) {
        _build(
          nodeType: nodeType,
          i: i,
          j: j,
          staticElement: staticElement,
        );
      }
    }
  }

  void _build({
    required NodeType nodeType,
    required int i,
    required int j,
    required StaticElement? staticElement,
  }) {
    if (nodeType.isMine) {
      _buildMine(
        type: nodeType,
        i: i,
        j: j,
        staticElement: staticElement,
      );
    } else if (nodeType.isTurret) {
      _buildTurret(
        type: nodeType,
        i: i,
        j: j,
        staticElement: staticElement,
      );
    }
  }

  void _buildMine({
    required NodeType type,
    required int i,
    required int j,
    required StaticElement? staticElement,
  }) {
    final ResourceType resourceType = type.resource!;

    if ((staticElement is Patch) &&
        staticElement.resourceType == resourceType) {
      addMine(
        i: i,
        j: j,
        type: resourceType,
      );
      state.resources.remove(type.cost);
    }
  }

  void _buildTurret({
    required NodeType type,
    required int i,
    required int j,
    required StaticElement? staticElement,
  }) {
    if (staticElement == null) {
      addTurret(
        i: i,
        j: j,
        type: type.turret!,
      );
      state.resources.remove(type.cost);
    }
  }
}
