import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/map_component.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/base/node_selected.dart';
import 'package:tensionnode/components/base/resources_hud.dart';
import 'package:tensionnode/components/game/bullet.dart';
import 'package:tensionnode/components/game/enemy.dart';
import 'package:tensionnode/components/game/kernel.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/dialog/contextual/build_menu.dart';
import 'package:tensionnode/dialog/global/main_menu.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/json/json_enemy.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/position.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/loader.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/spec/bullet_spec.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';
import 'package:tensionnode/types/direction.dart';

class GameComponent extends BaseGameComponent {
  late MapComponent map;
  final GameState state;

  GameComponent(this.state);

  @override
  Future onLoad() async {
    final JsonMatch jsonMatch = await Loader.match(Assets.MATCHES_MATCH1);
    state.load(jsonMatch);

    //add(Background(camera));
    add(FpsTextComponent(
      position: Vector2(
        10,
        size.y - 40,
      ),
      textRenderer: Style.textRenderer(size: 20),
    ));
    add(ResourcesHud());

    map = await MapComponent.load(Assets.TILES_MAP);
    add(map);

    final JsonNode kernelNode = jsonMatch.kernel;

    addNode(Kernel(
      i: kernelNode.position.x,
      j: kernelNode.position.y,
      shield: kernelNode.shield,
    ));

    for (final JsonNode node in jsonMatch.mines) {
      addMine(
        i: node.position.x,
        j: node.position.y,
        spec: node.type.spec as MineSpec,
        shield: node.shield,
      );
    }

    for (final JsonNode node in jsonMatch.turrets) {
      addTurret(
        i: node.position.x,
        j: node.position.y,
        spec: node.type.spec as TurretSpec,
        shield: node.shield,
      );
    }

    for (final JsonEnemy node in jsonMatch.enemies) {
      addEnemy(
        i: node.position.x,
        j: node.position.y,
        spec: node.type.spec as EnemySpec,
        shield: node.shield,
        direction: node.direction,
      );
    }

    return super.onLoad();
  }

  void addMine({
    required num i,
    required num j,
    required MineSpec spec,
    required num shield,
  }) {
    addNode(Mine(
      i: i,
      j: j,
      spec: spec,
      shield: shield,
    ));
  }

  void addTurret({
    required num i,
    required num j,
    required TurretSpec spec,
    required num shield,
  }) {
    addNode(Turret(
      i: i,
      j: j,
      spec: spec,
      shield: shield,
    ));
  }

  void addEnemy({
    required num i,
    required num j,
    required EnemySpec spec,
    required Direction direction,
    required num shield,
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
    required num weaponRange,
    required Vector2 startPosition,
    required Vector2 direction,
  }) {
    addNode(Bullet(
      shooter: shooter,
      spec: spec,
      weaponRange: weaponRange,
      startPosition: startPosition,
      direction: direction,
    ));
  }

  void addNode(Component node) {
    add(node);

    if (node is FixedNode) {
      state.addHeat(node);
    }
  }

  void removeNode(Node node) {
    try {
      remove(node);

      if (node is FixedNode) {
        state.removeHeat(node);
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  void onKeyPressed(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) {
      openMainMenu();
    } else if (key == LogicalKeyboardKey.space) {
      //_createTestObjects();
      spawnEnemy();
    }
  }

  void spawnEnemy() {
    final Direction direction = Direction.random();
    final Vector2 position = direction.randomStartPoint;

    addEnemy(
      i: position.x.toInt(),
      j: position.y.toInt(),
      spec: EnemySpec.enemy,
      direction: direction,
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

  void _closeContextualMenus() {
    closeMenu(name: BuildMenu.NAME);
  }

  void _closeModeMenus() {
    _disableBuildMode();
    _disableDeleteMode();
  }

  void openMainMenu() => openMenu(
        name: MainMenu.NAME,
        pauseGame: true,
      );

  void openBuildMenu() => openMenu(name: BuildMenu.NAME);

  void openMenu({
    required String name,
    bool pauseGame = false,
  }) {
    _closeContextualMenus();
    _closeModeMenus();

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
    bool unselectNode = false,
  }) {
    if (overlays.isActive(name)) {
      overlays.remove(name);

      if (unselectNode) {
        removeComponents(NodeSelected);
      }

      if (resumeGame) {
        resumeEngine();
      }
    }
  }

  bool selectNode(FixedNode node) {
    if (state.deleteMode) {
      node.destroy();
    } else if (!state.isInSpecialMode) {
      state.selectNode(node);
      removeComponents(NodeSelected);
      add(NodeSelected(node: node));
    }

    return true;
  }

  void unselectNode() {
    state.unselectNode();
    removeComponents(NodeSelected);
  }

  void enableBuildMode(FixedNodeSpec spec) {
    _closeContextualMenus();
    _closeModeMenus();

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
    _closeContextualMenus();
    _closeModeMenus();
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

  void onOpenResearch() {
    spawnEnemy();
    // TODO(momo): implement
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
      final MapTile tile = map.tile(
        i: i,
        j: j,
      );
      final FixedNodeSpec spec = buildingIndicator.spec;

      if ((node == null) && state.resources.has(spec.cost)) {
        _build(
          i: i,
          j: j,
          spec: spec,
          tile: tile,
        );
      }
    }
  }

  void _build({
    required int i,
    required int j,
    required NodeSpec spec,
    required MapTile tile,
  }) {
    if (spec is MineSpec) {
      _buildMine(
        i: i,
        j: j,
        spec: spec,
        tile: tile,
      );
    } else if (spec is TurretSpec) {
      _buildTurret(
        i: i,
        j: j,
        spec: spec,
        tile: tile,
      );
    }
  }

  void _buildMine({
    required int i,
    required int j,
    required MineSpec spec,
    required MapTile tile,
  }) {
    if (tile.isPatch(spec.resource)) {
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
    required MapTile tile,
  }) {
    if (tile.isGround) {
      addTurret(
        i: i,
        j: j,
        spec: spec,
        shield: Constants.SHIELD_MAX,
      );
      state.resources.remove(spec.cost);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    final int enemiesToSpawn = state.update(dt);

    for (int i = 0; i < enemiesToSpawn; i++) {
      spawnEnemy();
    }
  }
}
