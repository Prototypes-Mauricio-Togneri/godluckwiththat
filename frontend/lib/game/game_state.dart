import 'package:dafluta/dafluta.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/enemy.dart';
import 'package:tensionnode/components/game/kernel.dart';
import 'package:tensionnode/components/game/mine.dart';
import 'package:tensionnode/components/game/turret.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/menu_mode.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  Resources resources = Resources.empty();
  num heat = 0;
  num timeElapsed = 0;
  num timeSpawn = 0;

  Node? _selectedNode;
  MenuMode mode = MenuMode.none;

  late final JsonMatch jsonMatch;
  late final Kernel kernel;
  final List<Mine> mines = [];
  final List<Turret> turrets = [];
  final List<Enemy> enemies = [];

  bool get constructMode => mode == MenuMode.construct;

  bool get buildingMode => mode == MenuMode.building;

  bool get destroyingMode => mode == MenuMode.destroying;

  bool get isDetailsMode =>
      (mode == MenuMode.construct) || (mode == MenuMode.node_selected);

  bool get isInSpecialMode =>
      (mode == MenuMode.building) || (mode == MenuMode.destroying);

  @override
  void onLoad() {
    FlameAudio.audioCache.load(Assets.AUDIO_SFX_BULLET);
    FlameAudio.audioCache.load(Assets.AUDIO_SFX_LASER);
  }

  void load(JsonMatch json) {
    jsonMatch = json;
    resources = Resources(
      red: json.resources.red,
      green: json.resources.green,
      blue: json.resources.blue,
    );
  }

  T selectedNode<T>() => _selectedNode as T;

  bool isSelected(Type type) => _selectedNode.runtimeType == type;

  void selectNode(Node node) {
    _enableMode(MenuMode.node_selected);
    _selectedNode = node;
  }

  void unselectNode() => disableMode();

  void enableConstructMode() => _enableMode(MenuMode.construct);

  void disableConstructMode() => disableMode();

  void enableBuildingMode() => _enableMode(MenuMode.building);

  void disableBuildingMode() => disableMode();

  void enableDestroyingMode() => _enableMode(MenuMode.destroying);

  void disableDestroyingMode() => disableMode();

  void _enableMode(MenuMode newMode) {
    _selectedNode = null;
    mode = newMode;
    notify();
  }

  void disableMode() {
    _selectedNode = null;
    mode = MenuMode.none;
    notify();
  }

  int update(double dt) {
    int enemiesToSpawn = 0;

    timeElapsed += dt;
    timeSpawn += dt;

    if (timeSpawn > Constants.TIME_SPAWN) {
      timeSpawn -= Constants.TIME_SPAWN;
      enemiesToSpawn = 0; // TODO(momo): heat
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
      map: jsonMatch.map.withCamera(camera),
      resources: resources.json,
      kernel: kernel.json,
      mines: mines.map((e) => e.json).toList(),
      turrets: turrets.map((e) => e.json).toList(),
      enemies: enemies.map((e) => e.json).toList(),
    );
  }
}
