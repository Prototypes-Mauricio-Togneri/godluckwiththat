import 'package:dafluta/dafluta.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/menu_mode.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  num version = 0;
  String id = '';
  String map = '';
  Resources resources = Resources.empty();
  num heat = 0;
  num timeElapsed = 0;
  num timeSpawn = 0;

  Node? _selectedNode;
  MenuMode mode = MenuMode.none;

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

  void load(JsonMatch jsonMatch) {
    version = jsonMatch.version;
    id = jsonMatch.id;
    map = jsonMatch.map;
    resources = Resources(
      red: jsonMatch.resources.red,
      green: jsonMatch.resources.green,
      blue: jsonMatch.resources.blue,
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

  void addHeat(FixedNode node) {
    heat += node.heat;
  }

  void removeHeat(FixedNode node) {
    heat -= node.heat;
  }

  void addResource(ResourceType type) => resources.add(type);
}
