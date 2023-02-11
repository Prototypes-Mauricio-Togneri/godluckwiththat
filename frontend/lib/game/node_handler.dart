import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/ammo.dart';
import 'package:tensionnode/components/game/enemy.dart';
import 'package:tensionnode/components/game/kernel.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/spec/ammo_spec.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';

mixin NodeHandler on BaseGameComponent {
  void addKernel({
    required num i,
    required num j,
    required num shield,
  }) {
    addNode(Kernel(
      i: i,
      j: j,
      shield: shield,
    ));
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
    required int i,
    required int j,
    required num shield,
    required int shotsFired,
    required int kills,
    required TurretSpec spec,
  }) {
    addNode(Turret(
      i: i,
      j: j,
      shield: shield,
      shotsFired: shotsFired,
      kills: kills,
      spec: spec,
    ));
  }

  void addEnemy({
    required EnemySpec spec,
    required num shield,
    required Vector2 position,
    required Vector2 kernelPosition,
  }) {
    addNode(Enemy(
      spec: spec,
      position: position,
      shield: shield,
      kernelPosition: kernelPosition,
    ));
  }

  void addAmmo({
    required Node shooter,
    required AmmoSpec spec,
    required double weaponRange,
    required Vector2 startPosition,
    required Vector2 direction,
  }) {
    addNode(Ammo(
      shooter: shooter,
      spec: spec,
      weaponRange: weaponRange,
      startPosition: startPosition,
      direction: direction,
    ));
  }

  void addNode(Component node) {
    add(node);
    state.addNode(node);
  }

  void removeNode(Component node) {
    try {
      remove(node);
      state.removeNode(node);

      if (node is Kernel) {
        onGameOver();
      }
    } catch (e) {
      // ignore
    }
  }

  void onGameOver() {}

  void build({
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
        shield: Constants.SHIELD_MAX,
        shotsFired: 0,
        kills: 0,
        spec: spec,
      );
      state.resources.remove(spec.cost);
    }
  }
}
