import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/background.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/map_element.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/resources_hud.dart';
import 'package:tensionnode/components/game/bullet.dart';
import 'package:tensionnode/components/game/enemy.dart';
import 'package:tensionnode/components/game/kernel.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/patch.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/dialog/contextual/build_menu.dart';
import 'package:tensionnode/dialog/contextual/mine_menu.dart';
import 'package:tensionnode/dialog/contextual/turret_menu.dart';
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
import 'package:tensionnode/spec/bullet_spec.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';
import 'package:tensionnode/types/direction.dart';

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
      final NodeSpec spec = node.type.spec;

      if (spec is MineSpec) {
        addMine(
          i: node.position.x,
          j: node.position.y,
          spec: spec,
          shield: node.shield,
        );
      } else if (spec is TurretSpec) {
        addTurret(
          i: node.position.x,
          j: node.position.y,
          spec: spec,
          shield: node.shield,
        );
      } else if (node.type.isKernel) {
        addNode(Kernel(
          i: node.position.x,
          j: node.position.y,
          shield: node.shield,
        ));
      }
    }

    return super.onLoad();
  }

  void addMine({
    required int i,
    required int j,
    required MineSpec spec,
    required double shield,
  }) {
    addNode(Mine(
      i: i,
      j: j,
      spec: spec,
      shield: shield,
    ));
  }

  void addTurret({
    required int i,
    required int j,
    required TurretSpec spec,
    required double shield,
  }) {
    addNode(Turret(
      i: i,
      j: j,
      spec: spec,
      shield: shield,
    ));
  }

  void addEnemy({
    required int i,
    required int j,
    required EnemySpec spec,
    required Direction direction,
    required double shield,
  }) {
    addNode(Enemy(
      spec: spec,
      direction: direction,
      position: Position.fromGrid(i, j),
      shield: shield,
    ));
  }

  void addBullet({
    required Node shooter,
    required BulletSpec spec,
    required Vector2 startPosition,
    required Vector2 direction,
  }) {
    addNode(Bullet(
      shooter: shooter,
      spec: spec,
      startPosition: startPosition,
      direction: direction,
    ));
  }

  void addNode(Component node) {
    add(node);
  }

  void removeNode(Node node) {
    try {
      remove(node);
    } catch (e) {
      // ignore
    }
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
      j: 6,
      spec: EnemySpec.enemy,
      direction: Direction.right,
      shield: Constants.SHIELD_MAX,
    );
  }

  /*void _createTestObjects() {
    for (int i = -15; i < 15; i++) {
      for (int j = -15; j < 15; j++) {
        addNode(Enemy(
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
    closeMenu(name: TurretMenu.NAME);
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

  void enableBuildMode(NodeSpec spec) {
    _disableBuildMode();
    _closeContextualMenus();

    // TODO(momo): don't add it for mobile
    removeComponents(BuildingIndicator);
    add(BuildingIndicator(spec: spec));

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
      final MapElement? mapElement = getMapElement(i, j);
      final NodeSpec spec = buildingIndicator.spec;

      if ((node == null) && state.resources.has(spec.cost)) {
        _build(
          i: i,
          j: j,
          spec: spec,
          mapElement: mapElement,
        );
      }
    }
  }

  void _build({
    required int i,
    required int j,
    required NodeSpec spec,
    required MapElement? mapElement,
  }) {
    if (spec is MineSpec) {
      _buildMine(
        i: i,
        j: j,
        spec: spec,
        mapElement: mapElement,
      );
    } else if (spec is TurretSpec) {
      _buildTurret(
        i: i,
        j: j,
        spec: spec,
        mapElement: mapElement,
      );
    }
  }

  void _buildMine({
    required int i,
    required int j,
    required MineSpec spec,
    required MapElement? mapElement,
  }) {
    if ((mapElement is Patch) && (mapElement.resourceType == spec.resource)) {
      addMine(
        i: i,
        j: j,
        spec: spec,
        shield: Constants.SHIELD_MAX,
      );
      state.resources.remove(spec.cost);
    }
  }

  void _buildTurret({
    required int i,
    required int j,
    required TurretSpec spec,
    required MapElement? mapElement,
  }) {
    if (mapElement == null) {
      addTurret(
        i: i,
        j: j,
        spec: spec,
        shield: Constants.SHIELD_MAX,
      );
      state.resources.remove(spec.cost);
    }
  }
}
