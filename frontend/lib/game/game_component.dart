import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/extensions/list_extension.dart';
import 'package:tensionnode/extensions/random_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/menu_handler.dart';
import 'package:tensionnode/game/node_handler.dart';
import 'package:tensionnode/json/json_enemy.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/json/json_turret.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';

class GameComponent extends BaseGameComponent with MenuHandler, NodeHandler {
  GameComponent(super.state);

  @override
  Future onLoad() async {
    await addBaseComponents(state.jsonMatch);

    addKernel(
      i: state.jsonMatch.kernel.position.x,
      j: state.jsonMatch.kernel.position.y,
      health: state.jsonMatch.kernel.health,
    );

    for (final JsonNode node in state.jsonMatch.mines) {
      addMine(
        i: node.position.x,
        j: node.position.y,
        spec: node.type.spec as MineSpec,
        health: node.health,
      );
    }

    for (final JsonTurret turret in state.jsonMatch.turrets) {
      addTurret(
        i: turret.position.x.toInt(),
        j: turret.position.y.toInt(),
        health: turret.health,
        shotsFired: turret.shotsFired,
        kills: turret.kills,
        spec: turret.type.spec as TurretSpec,
      );
    }

    for (final JsonEnemy enemy in state.jsonMatch.enemies) {
      addEnemy(
        spec: enemy.type.spec as EnemySpec,
        health: enemy.health,
        position: enemy.position.vector,
        kernelPosition: state.kernel.position,
      );
    }

    return super.onLoad();
  }

  @override
  void onKeyPressed(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) {
      openMainMenu();
    } else if (key == LogicalKeyboardKey.space) {
      onShowDetails();
    }
  }

  void onShowDetails() {
    // TODO(momo): implement
  }

  void _spawnEnemy(EnemySpec spec) {
    final double distance = mapSize * 0.7 * Constants.NODE_SIZE;
    final int angle = Random().between(0, 359);
    final Vector2 position = Vector2(
      distance * sin(angle),
      distance * cos(angle),
    );

    addEnemy(
      spec: spec,
      health: spec.health,
      position: position,
      kernelPosition: state.kernel.position,
    );
  }

  @override
  void onMapClicked(Vector2 position) {
    if (isDetailsMode) {
      removeMenuComponents();
      disableMode();
    }

    if (buildingMode) {
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
  void onGameOver() => openGameOverMenu();

  @override
  void update(double dt) {
    super.update(dt);

    final int enemiesToSpawn = state.update(dt);
    final List<EnemySpec> specs = [
      EnemySpec.enemy1,
      EnemySpec.enemy2,
      EnemySpec.enemy3,
    ];

    for (int i = 0; i < enemiesToSpawn; i++) {
      _spawnEnemy(specs.random);
    }
  }
}
