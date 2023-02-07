import 'package:dafluta/dafluta.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/game/enemy.dart';
import 'package:tensionnode/components/game/kernel.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  num heat = 0;
  num timeElapsed = 0;
  num timeSpawn = 0;

  final Resources resources = Resources.empty();
  late final Kernel kernel;
  final List<Mine> mines = [];
  final List<Turret> turrets = [];
  final List<Enemy> enemies = [];
  final JsonMatch jsonMatch;

  GameState(this.jsonMatch) {
    resources.set(
      red: jsonMatch.resources.red,
      green: jsonMatch.resources.green,
      blue: jsonMatch.resources.blue,
    );
  }

  int update(double dt) {
    int enemiesToSpawn = 0;

    timeElapsed += dt;
    timeSpawn += dt;

    if (timeSpawn > Constants.TIME_SPAWN) {
      timeSpawn -= Constants.TIME_SPAWN;
      enemiesToSpawn = heat ~/ 60;
      enemiesToSpawn = (enemiesToSpawn == 0) ? 1 : enemiesToSpawn;
    }

    return enemiesToSpawn;
  }

  void addResource(ResourceType type) => resources.add(type);

  void addNode(Component node) {
    if (node is Kernel) {
      kernel = node;
    } else if (node is Mine) {
      mines.add(node);
    } else if (node is Turret) {
      turrets.add(node);
    } else if (node is Enemy) {
      enemies.add(node);
    }

    if (node is FixedNode) {
      heat += node.heat;
    }
  }

  void removeNode(Component node) {
    if (node is Mine) {
      mines.remove(node);
    } else if (node is Turret) {
      turrets.remove(node);
    } else if (node is Enemy) {
      enemies.remove(node);
    }

    if (node is FixedNode) {
      heat -= node.heat;
    }
  }

  JsonMatch getMatch(Camera camera) {
    return JsonMatch(
      version: jsonMatch.version,
      id: jsonMatch.id,
      timeElapsed: jsonMatch.timeElapsed,
      map: jsonMatch.map.withCamera(camera),
      mode: jsonMatch.mode,
      resources: resources.json,
      kernel: kernel.json,
      mines: mines.map((e) => e.json).toList(),
      turrets: turrets.map((e) => e.json).toList(),
      enemies: enemies.map((e) => e.json).toList(),
    );
  }
}
