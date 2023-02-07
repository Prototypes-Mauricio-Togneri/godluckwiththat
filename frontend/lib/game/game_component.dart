import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/building_indicator.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/dialog/game_over_menu.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/extensions/random_extension.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/game/menu_handler.dart';
import 'package:tensionnode/game/node_handler.dart';
import 'package:tensionnode/json/json_enemy.dart';
import 'package:tensionnode/json/json_match.dart';
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

    for (final JsonTurret turret in jsonMatch.turrets) {
      addTurret(
        i: turret.position.x.toInt(),
        j: turret.position.y.toInt(),
        shield: turret.shield,
        shotsFired: turret.shotsFired,
        kills: turret.kills,
        spec: turret.type.spec as TurretSpec,
      );
    }

    for (final JsonEnemy enemy in jsonMatch.enemies) {
      addEnemy(
        spec: enemy.type.spec as EnemySpec,
        shield: enemy.shield,
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
      spawnEnemy();
    }
  }

  void onShowDetails() {
    // TODO(momo): implement
    spawnEnemy();
  }

  void spawnEnemy() {
    const double distance = 30 * Constants.NODE_SIZE;
    final int angle = Random().between(0, 359);
    final Vector2 position = Vector2(
      distance * sin(angle),
      distance * cos(angle),
    );

    addEnemy(
      spec: EnemySpec.enemy,
      shield: Constants.SHIELD_MAX,
      position: position,
      kernelPosition: state.kernel.position,
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
  void onGameOver() => openMenu(
        name: GameOverMenu.NAME,
        pauseGame: true,
      );

  @override
  void update(double dt) {
    super.update(dt);

    final int enemiesToSpawn = state.update(dt);

    for (int i = 0; i < enemiesToSpawn; i++) {
      spawnEnemy();
    }
  }
}
