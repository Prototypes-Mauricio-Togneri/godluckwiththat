import 'package:dafluta/dafluta.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/game/enemy.dart';
import 'package:tensionnode/components/game/kernel.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  num _totalTimeElapsed = 0;
  int _nextWave = 0;
  num _timeToNextWave = 0;

  final Resources resources = Resources.empty();
  late final Kernel kernel;
  final List<Mine> mines = [];
  final List<Turret> turrets = [];
  final List<Enemy> enemies = [];
  final JsonMatch jsonMatch;

  int get nextWave => _nextWave;

  int get timeToNextWave => _timeToNextWave.toInt();

  GameState(this.jsonMatch) {
    _totalTimeElapsed = jsonMatch.totalTimeElapsed;
    _nextWave = jsonMatch.nextWave;
    _timeToNextWave = jsonMatch.timeToNextWave;
    resources.set(
      red: jsonMatch.resources.red,
      green: jsonMatch.resources.green,
      blue: jsonMatch.resources.blue,
    );
  }

  int update(double dt) {
    int enemiesToSpawn = 0;

    _totalTimeElapsed += dt;
    _timeToNextWave -= dt;

    if (_timeToNextWave <= 0) {
      enemiesToSpawn = _nextWave * 10;
      _nextWave++;
      _timeToNextWave = Constants.TIME_TO_NEXT_WAVE;
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

    /*if (node is FixedNode) {
      _heat += node.heat;
    }*/
  }

  void removeNode(Component node) {
    if (node is Mine) {
      mines.remove(node);
    } else if (node is Turret) {
      turrets.remove(node);
    } else if (node is Enemy) {
      enemies.remove(node);
    }

    /*if (node is FixedNode) {
      _heat -= node.heat;
    }*/
  }

  JsonMatch getMatch(Camera camera) {
    return JsonMatch(
      version: jsonMatch.version,
      id: jsonMatch.id,
      totalTimeElapsed: _totalTimeElapsed.decimal(),
      nextWave: _nextWave,
      timeToNextWave: _timeToNextWave.decimal(),
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
