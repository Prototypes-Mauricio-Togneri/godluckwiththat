import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/menu_handler.dart';
import 'package:tensionnode/game/node_handler.dart';
import 'package:tensionnode/json/json_enemy.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';
import 'package:tensionnode/types/direction.dart';

class GameComponent extends BaseGameComponent with MenuHandler, NodeHandler {
  GameComponent(super.state);

  @override
  Future onLoad() async {
    final JsonMatch jsonMatch = JsonMatch.fromString(Constants.TEST_MATCH);
    state.load(jsonMatch);

    await addBaseComponents(jsonMatch);

    addKernel(
      i: jsonMatch.kernel.position.x,
      j: jsonMatch.kernel.position.y,
      shield: jsonMatch.kernel.shield,
    );

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

  @override
  void onKeyPressed(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) {
      openMainMenu();
    } else if (key == LogicalKeyboardKey.space) {
      spawnEnemy();
    }
  }

  void onOpenResearch() {
    // TODO(momo): implement
    spawnEnemy();
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

  @override
  void onMapClicked(Vector2 position) {
    if (state.isDetailsMode) {
      removeMenuComponents();
      state.disableMode();
    }

    if (state.buildingMode) {
      final BuildingIndicator buildingIndicator =
          getComponent(BuildingIndicator);
      final int i = position.x.toInt();
      final int j = position.y.toInt();
      final FixedNode? node = getFixedNode(i, j);
      final MapTile tile = getTile(
        i: i,
        j: j,
      );
      final FixedNodeSpec spec = buildingIndicator.spec;

      if ((node == null) && state.resources.has(spec.cost)) {
        build(
          i: i,
          j: j,
          spec: spec,
          tile: tile,
        );
      }
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
