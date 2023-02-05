import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/bullet.dart';
import 'package:tensionnode/components/game/enemy.dart';
import 'package:tensionnode/components/game/kernel.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/game/base_game_component.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/map_tile.dart';
import 'package:tensionnode/models/position.dart';
import 'package:tensionnode/spec/bullet_spec.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';
import 'package:tensionnode/types/direction.dart';

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
        spec: spec,
        shield: Constants.SHIELD_MAX,
      );
      state.resources.remove(spec.cost);
    }
  }

  JsonMatch getMatch() {
    final Kernel kernel = getComponent(Kernel);

    return JsonMatch(
      version: state.version,
      id: state.id,
      map: state.map,
      resources: state.resources.json,
      kernel: kernel.json,
      mines: [],
      turrets: [],
      enemies: [],
    );
  }
}
