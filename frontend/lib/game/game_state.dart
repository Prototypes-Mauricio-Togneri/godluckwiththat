import 'package:dafluta/dafluta.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/types/resource_type.dart';

class GameState extends BaseState {
  int version = 0;
  String id = '';
  int red = 0;
  int green = 0;
  int blue = 0;

  dynamic selectedNode;
  bool _buildMode = false;
  bool _deleteMode = false;

  bool get showCancel => _buildMode || _deleteMode;

  bool get buildMode => _buildMode;

  bool get deleteMode => _deleteMode;

  void load(JsonMatch jsonMatch) {
    version = jsonMatch.version;
    id = jsonMatch.id;
    red = jsonMatch.resources.red;
    green = jsonMatch.resources.green;
    blue = jsonMatch.resources.blue;
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

  void addResource(ResourceType type) {
    switch (type) {
      case ResourceType.red:
        red++;
        break;
      case ResourceType.green:
        green++;
        break;
      case ResourceType.blue:
        blue++;
        break;
    }
  }
}
