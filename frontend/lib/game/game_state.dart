import 'package:dafluta/dafluta.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  num version = 0;
  String id = '';
  Resources resources = Resources.empty();
  num heat = 0;
  num timeElapsed = 0;
  num timeSpawn = 0;

  Node? _selectedNode;
  bool _buildMode = false;
  bool _deleteMode = false;

  bool get showCancel => _buildMode || _deleteMode;

  bool get buildMode => _buildMode;

  bool get deleteMode => _deleteMode;

  bool get isInSpecialMode => buildMode || deleteMode;

  @override
  void onLoad() {
    FlameAudio.audioCache.load(Assets.AUDIO_SFX_BULLET);
    FlameAudio.audioCache.load(Assets.AUDIO_SFX_LASER);
  }

  void load(JsonMatch jsonMatch) {
    version = jsonMatch.version;
    id = jsonMatch.id;
    resources = Resources(
      red: jsonMatch.resources.red,
      green: jsonMatch.resources.green,
      blue: jsonMatch.resources.blue,
    );
  }

  T selectedNode<T>() => _selectedNode as T;

  bool isSelected(Type type) => _selectedNode.runtimeType == type;

  void selectNode(Node node) {
    _selectedNode = node;
    notify();
  }

  void unselectNode() {
    _selectedNode = null;
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

  void enableBuildMode() {
    _buildMode = true;
    notify();
  }

  void disableBuildMode() {
    _buildMode = false;
    notify();
  }

  void enableDeleteMode() {
    _deleteMode = true;
    notify();
  }

  void disableDeleteMode() {
    _deleteMode = false;
    notify();
  }

  void addResource(ResourceType type) => resources.add(type);
}
